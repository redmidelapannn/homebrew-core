class Bettercap < Formula
  desc "Complete, modular, portable and easily extensible MITM framework"
  homepage "https://www.bettercap.org/"
  url "https://github.com/evilsocket/bettercap/archive/v1.6.2.tar.gz"
  sha256 "1b364d7e31be5fa7b5f93eefe76763ad7bd4ac0b7b6bb4af05483157580a9cb9"
  revision 3

  bottle do
    cellar :any
    sha256 "6cc4f82064e65d472bf0c5d7e3543ec399e126d921e470ed3b08dd120d7b74a9" => :high_sierra
    sha256 "e96ed294edc44e558653f6d9fe4f6f0c8c875cb765239b0e1944340a92c6dc95" => :sierra
    sha256 "924176aa60163a483dc0ea6f04fdab51499f42046192f3212cdc26e82372a05e" => :el_capitan
  end

  depends_on "openssl"
  depends_on "ruby"

  def install
    ENV["GEM_HOME"] = libexec
    ENV["BUNDLE_PATH"] = libexec
    ENV.prepend "CPPFLAGS", "-I#{Formula["openssl"].opt_include}"
    system "gem", "install", "bundler"
    system libexec/"bin/bundle", "install"
    system "gem", "build", "bettercap.gemspec"
    system "gem", "install", "bettercap-#{version}.gem"
    bin.install libexec/"bin/bettercap"
    bin.env_script_all_files(libexec/"bin", :GEM_HOME => ENV["GEM_HOME"])
  end

  def caveats; <<~EOS
    bettercap requires root privileges so you will need to run `sudo bettercap`.
    You should be certain that you trust any software you grant root privileges.
    EOS
  end

  test do
    assert_match "This software must run as root.", pipe_output("#{bin}/bettercap --version 2>&1")
  end
end
