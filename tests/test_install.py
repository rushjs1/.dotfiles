"""Safe installer regression checks: temporary HOME, isolated PATH, no downloads.

Run with: python3 -m unittest discover -s tests -v
"""
from pathlib import Path
import shutil
import subprocess
import tempfile
import unittest

ROOT = Path(__file__).resolve().parents[1]


class InstallTests(unittest.TestCase):
    def setUp(self):
        self.temp = tempfile.TemporaryDirectory()
        self.addCleanup(self.temp.cleanup)
        self.root = Path(self.temp.name)
        self.home = self.root / 'home'
        self.home.mkdir()
        self.bin = self.root / 'bin'
        self.bin.mkdir()
        self.log = self.root / 'commands'
        self.repo = self.root / 'dotfiles'
        self.repo.mkdir()
        # Redirect absolute Homebrew discovery paths away from the real host.
        script = (ROOT / 'install.sh').read_text()
        for prefix in ('/opt/homebrew', '/usr/local', '/home/linuxbrew/.linuxbrew'):
            script = script.replace(prefix, str(self.root / prefix.lstrip('/')))
        (self.repo / 'install.sh').write_text(script)
        for name in ('.ideavimrc', '.gitconfig', '.zshrc', '.wezterm.lua'):
            (self.repo / name).touch()
        for name in ('ghostty/config', 'herdr/config.toml', 'skills/example/SKILL.md'):
            target = self.repo / name
            target.parent.mkdir(parents=True, exist_ok=True)
            target.touch()
        (self.repo / 'nvim-lazy').mkdir()
        for name in ('date', 'dirname', 'basename', 'mkdir', 'mv', 'ln', 'readlink', 'bash'):
            (self.bin / name).symlink_to(shutil.which(name))
        for name in ('cc', 'make', 'ps', 'file', 'git'):
            self.stub(name, 'exit 0')
        self.stub('curl', 'echo "download blocked" >&2; exit 97')
        self.stub('brew', '''printf '%s\\n' "brew $*" >> "$TEST_LOG"
if [[ "$1" == shellenv ]]; then
  printf 'export PATH="%s:$PATH"\\n' "$(dirname "$0")"
fi''')
        self.stub('uname', 'echo "$TEST_OS"')
        self.stub('composer', 'echo composer >> "$TEST_LOG"')
        self.stub('valet', 'echo "valet $*" >> "$TEST_LOG"')
        (self.home / '.nvm').mkdir()
        (self.home / '.nvm/nvm.sh').write_text('nvm() { echo "nvm $*" >> "$TEST_LOG"; }\n')
        self.env = dict(HOME=str(self.home), PATH=str(self.bin), TEST_OS='Linux',
                        TEST_LOG=str(self.log), INSTALL_VALET='0')

    def stub(self, name, body):
        path = self.bin / name
        path.write_text('#!/bin/bash\n' + body + '\n')
        path.chmod(0o755)

    def run_install(self):
        return subprocess.run(['/bin/bash', str(self.repo / 'install.sh')],
                              env=self.env, text=True, capture_output=True)

    def test_linux_and_macos_are_repeatable_and_preserve_existing_files(self):
        for platform in ('Linux', 'Darwin'):
            with self.subTest(platform=platform):
                self.env['TEST_OS'] = platform
                first = self.run_install()
                self.assertEqual(first.returncode, 0, first.stderr)
                target = self.home / '.zshrc'
                target.unlink()
                target.write_text('existing config')
                second = self.run_install()
                self.assertEqual(second.returncode, 0, second.stderr)
                self.assertTrue(target.is_symlink())
                backups = list((self.home / '.dotfiles-backups').glob('*/.zshrc'))
                self.assertTrue(any(p.read_text() == 'existing config' for p in backups))
                self.assertIn('Already linked:', second.stdout)
                self.assertIn('brew bundle --file=', self.log.read_text())
                self.assertIn('nvm install --lts', self.log.read_text())

    def test_unsupported_os_fails_before_linking(self):
        self.env['TEST_OS'] = 'FreeBSD'
        self.assertNotEqual(self.run_install().returncode, 0)
        self.assertFalse((self.home / '.zshrc').exists())

    def test_linux_valet_fails_before_linking(self):
        self.env['INSTALL_VALET'] = '1'
        result = self.run_install()
        self.assertNotEqual(result.returncode, 0)
        self.assertIn('Valet requires macOS', result.stderr)
        self.assertFalse((self.home / '.zshrc').exists())

    def test_missing_linux_prerequisite_fails_before_linking(self):
        (self.bin / 'cc').unlink()
        result = self.run_install()
        self.assertNotEqual(result.returncode, 0)
        self.assertIn('build-essential', result.stderr)
        self.assertFalse((self.home / '.zshrc').exists())

    def test_linuxbrew_discovered_outside_path(self):
        location = self.root / 'home/linuxbrew/.linuxbrew/bin'
        location.mkdir(parents=True)
        (self.bin / 'brew').rename(location / 'brew')
        result = self.run_install()
        self.assertEqual(result.returncode, 0, result.stderr)
        self.assertIn('Homebrew is already installed', result.stdout)

    def test_failed_bootstrap_download_stops_before_bundle(self):
        (self.bin / 'brew').unlink()
        result = self.run_install()
        self.assertNotEqual(result.returncode, 0)
        self.assertIn('download blocked', result.stderr)
        self.assertFalse(self.log.exists())

    def test_macos_valet_remains_available(self):
        self.env.update(TEST_OS='Darwin', INSTALL_VALET='1')
        result = self.run_install()
        self.assertEqual(result.returncode, 0, result.stderr)
        self.assertIn('valet park', self.log.read_text())


if __name__ == '__main__':
    unittest.main()
