class Libmagic < Formula
  desc "Implementation of the file(1) command"
  homepage "https://www.darwinsys.com/file/"
  url "ftp://ftp.astron.com/pub/file/file-5.30.tar.gz"
  mirror "https://fossies.org/linux/misc/file-5.30.tar.gz"
  sha256 "694c2432e5240187524c9e7cf1ec6acc77b47a0e19554d34c14773e43dbbf214"

  bottle do
    rebuild 1
    sha256 "8d1809274720e41f735ac3cc1eef44ed7e87a927c2a8d8f359047b28185f94dc" => :sierra
    sha256 "cb970eb82a551764113062ad5307b292238f93ad45a93fcdbc0dce6f9725dd0c" => :el_capitan
    sha256 "163017d3cac28434bf4afb8fd1860d5b50f86c3068b7f1d8da28a3672b7756a7" => :yosemite
  end

  depends_on :python => :optional

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--enable-fsect-man5",
                          "--enable-static"
    system "make", "install"
    (share+"misc/magic").install Dir["magic/Magdir/*"]

    if build.with? "python"
      cd "python" do
        system "python", *Language::Python.setup_install_args(prefix)
      end
    end

    # Don't dupe this system utility
    rm bin/"file"
    rm man1/"file.1"
  end
end
