class Osh < Formula
  desc "Two ports of /bin/sh from V6 UNIX (circa 1975)"
  homepage "https://v6shell.org/"
  url "https://v6shell.org/src/osh-4.3.0.tar.gz"
  sha256 "1173b8feffb617c0ed249f6cb7aff482eae960d8ccfb89f38ed73dab37dae5ed"
  version_scheme 1
  head "https://github.com/JNeitzel/v6shell.git"

  bottle do
    rebuild 1
    sha256 "711c9cb1729c7b33f533fbaefe3987f8ab813b88612113ad9a7c2e297f6602f2" => :sierra
    sha256 "13d766a52aac686d74bc6659414d040c00e1b687b4d7dc59b7bcb8e539a3993b" => :el_capitan
    sha256 "8e9b8157a2506823b25eee7b9114be533bcab13d2a141ef5083adec48442559c" => :yosemite
  end

  option "with-examples", "Build with shell examples"

  resource "examples" do
    url "https://v6shell.org/v6scripts/v6scripts-20160128.tar.gz"
    sha256 "c23251137de67b042067b68f71cd85c3993c566831952af305f1fde93edcaf4d"
  end

  def install
    system "make", "install", "PREFIX=#{prefix}", "SYSCONFDIR=#{etc}", "MANDIR=#{man}"

    if build.with? "examples"
      resource("examples").stage do
        ENV.prepend_path "PATH", bin
        system "./INSTALL", libexec
      end
    end
  end

  test do
    assert_match "brew!", shell_output("#{bin}/osh -c 'echo brew!'").strip

    if build.with? "examples"
      ENV.prepend_path "PATH", libexec
      assert_match "1 3 5 7 9 11 13 15 17 19", shell_output("#{libexec}/counts").strip
    end
  end
end
