class Libcroco < Formula
  desc "CSS parsing and manipulation toolkit for GNOME"
  homepage "http://www.linuxfromscratch.org/blfs/view/svn/general/libcroco.html"
  url "https://download.gnome.org/sources/libcroco/0.6/libcroco-0.6.11.tar.xz"
  sha256 "132b528a948586b0dfa05d7e9e059901bca5a3be675b6071a90a90b81ae5a056"

  bottle do
    cellar :any
    rebuild 1
    sha256 "a03f08851e59a2537f05e65896c375357888bfa1a8a4e3d303a048454125722f" => :sierra
    sha256 "b9ac6e78474eec555226c51c90ca7fc8430091b0476e0996c29bb9f0e3e54faf" => :el_capitan
    sha256 "c2bf4937bc6f29ade590a609b92750c80a5e5f16311873ddf56d8ffd9b27e55b" => :yosemite
  end

  depends_on "pkg-config" => :build
  depends_on "intltool" => :build
  depends_on "glib"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--disable-Bsymbolic"
    system "make", "install"
  end

  test do
    (testpath/"test.css").write ".brew-pr { color: green }"
    assert_equal ".brew-pr {\n  color : green\n}",
      shell_output("#{bin}/csslint-0.6 test.css").chomp
  end
end
