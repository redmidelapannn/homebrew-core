class Sassc < Formula
  desc "Wrapper around libsass that helps to create command-line apps"
  homepage "https://github.com/sass/sassc"
  url "https://github.com/sass/sassc.git", :tag => "3.4.9", :revision => "a839dfa14c81c6e772eb08cfd5ea2941315b984d"
  head "https://github.com/sass/sassc.git"

  bottle do
    cellar :any
    sha256 "da6e274bd2420f65c2d406f06520ee0a302d35c1b35bf6c526c6d78966a6949b" => :high_sierra
    sha256 "2495c6ea5a98f300d7246b98a4435dfc60f8ae24ee5841e5e312935e04baad62" => :sierra
    sha256 "1474d3d9ed4ed22f79c3f44eb930e16f01daf0500ebc76e0ebb60e8be5cefd94" => :el_capitan
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "libsass"

  def install
    system "autoreconf", "-fvi"
    system "./configure", "--prefix=#{prefix}", "--disable-silent-rules",
                          "--disable-dependency-tracking"
    system "make", "install"
  end

  test do
    (testpath/"input.scss").write <<~EOS
      div {
        img {
          border: 0px;
        }
      }
    EOS

    assert_equal "div img{border:0px}",
    shell_output("#{bin}/sassc --style compressed input.scss").strip
  end
end
