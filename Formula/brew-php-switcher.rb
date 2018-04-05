class BrewPhpSwitcher < Formula
  desc "Switch Apache / Valet / CLI configs between PHP versions"
  homepage "https://github.com/philcook/php-switcher"
  url "https://github.com/philcook/brew-php-switcher/archive/v2.0.tar.gz"
  sha256 "c2303b1b1a66ee90ed900c3beabacd6aa4e921dbcad5242e399c45d86899bc88"
  head "https://github.com/philcook/brew-php-switcher.git"

  def install
    bin.install "phpswitch.sh"
    sh = libexec + "brew-php-switcher"
    sh.write("#!/usr/bin/env sh\n\nsh #{bin}/phpswitch.sh $*")
    chmod 0755, sh
    bin.install_symlink sh
  end

  def caveats; <<~EOS
    To run brew php switcher do the following:
      "brew-php-switcher 7.2".

    You can select php version 5.6, 7.0, 7.1, or 7.2.
    EOS
  end

  test do
    system "#{bin}/brew-php-switcher"
  end
end
