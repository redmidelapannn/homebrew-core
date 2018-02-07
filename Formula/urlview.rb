class Urlview < Formula
  desc "URL extractor/launcher"
  homepage "https://packages.debian.org/sid/misc/urlview"
  url "https://mirrors.ocf.berkeley.edu/debian/pool/main/u/urlview/urlview_0.9.orig.tar.gz"
  mirror "https://mirrorservice.org/sites/ftp.debian.org/debian/pool/main/u/urlview/urlview_0.9.orig.tar.gz"
  version "0.9-20"
  sha256 "746ff540ccf601645f500ee7743f443caf987d6380e61e5249fc15f7a455ed42"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "ab5a106ac9f3fd7c2485319f0e033df59b13e3d96462018b71a47b9b42082e6d" => :high_sierra
    sha256 "6c4210f53268284726f7456fe721cdb038c05f5abbeb537adabe9446bfd07afd" => :sierra
    sha256 "09952d25b83f1c3fe5b154c3c24584cae71f1f6a1cb70bef28169ab4a3e2afa3" => :el_capitan
  end

  patch do
    url "https://mirrors.ocf.berkeley.edu/debian/pool/main/u/urlview/urlview_0.9-20.diff.gz"
    mirror "https://mirrorservice.org/sites/ftp.debian.org/debian/pool/main/u/urlview/urlview_0.9-20.diff.gz"
    sha256 "0707956fd7195aefe6d6ff2eaabe8946e3d18821a1ce97c0f48d0f8d6e37514e"
  end

  def install
    inreplace "urlview.man", "/etc/urlview/url_handler.sh", "open"
    inreplace "urlview.c",
      '#define DEFAULT_COMMAND "/etc/urlview/url_handler.sh %s"',
      '#define DEFAULT_COMMAND "open %s"'

    man1.mkpath
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}",
                          "--sysconfdir=#{etc}"
    system "make", "install"
  end

  test do
    (testpath/"urlfile").write <<~EOS
      https://www.github.com
    EOS
    require "pty"
    PTY.spawn(bin/"urlview", testpath/"urlfile") do |_stdout, stdin, _pid|
      sleep 2
      stdin.write "q"
    end
  end
end
