class Wput < Formula
  desc "Tiny, wget-like FTP client for uploading files"
  homepage "https://wput.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/wput/wput/0.6.2/wput-0.6.2.tgz"
  sha256 "229d8bb7d045ca1f54d68de23f1bc8016690dc0027a16586712594fbc7fad8c7"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "13bbe1bb43bb836692b9e52519d3da941d8ea46383f66e76c4d81a905ec611d2" => :catalina
    sha256 "561beb2cf14913147762aeed8b24944ef980f567a9c5c2e4fe02be8bf3cfea69" => :mojave
    sha256 "99a18c7905e3541f70a6153e6d0149f7baeaea573f53569d5538670a1ae84ea0" => :high_sierra
  end

  # The patch is to skip inclusion of malloc.h only on OSX. Upstream:
  # https://sourceforge.net/p/wput/patches/22/
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/85fa66a9/wput/0.6.2.patch"
    sha256 "a3c47a12344b6f67a5120dd4f838172e2af04f4d97765cc35d22570bcf6ab727"
  end

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make"
    ENV.deparallelize
    system "make", "install"
  end

  test do
    system "#{bin}/wput", "--version"
  end
end
