class Graphviz < Formula
  desc "Graph visualization software from AT&T and Bell Labs"
  homepage "http://graphviz.org/"

  stable do
    url "http://graphviz.org/pub/graphviz/stable/SOURCES/graphviz-2.38.0.tar.gz"
    mirror "https://mirrors.ocf.berkeley.edu/debian/pool/main/g/graphviz/graphviz_2.38.0.orig.tar.gz"
    sha256 "81aa238d9d4a010afa73a9d2a704fc3221c731e1e06577c2ab3496bdef67859e"

    # https://github.com/ellson/graphviz/commit/f97c86e
    # Support either version of ghostcript's error prefixes
    patch do
      url "https://raw.githubusercontent.com/Homebrew/formula-patches/6a6a1a3/graphviz/patch-gvloadimage_gs.c.diff"
      sha256 "bcc0758dd9e0ac17bd1cde63a55a613124814002b470ac4a7a0c421c83a253ab"
    end
  end

  bottle do
    rebuild 1
    sha256 "d09daeb9766359bead2bef8b9f3cc83eda78a381e4c607e2552f06516624bc9f" => :sierra
    sha256 "cf69eac548a5c02aacc966706fc4a922176059414fbe453680aae4552fc019dc" => :el_capitan
    sha256 "6817a366691db684f2910dfbc7e20253915f82848ae09ef474a50ac67bf10582" => :yosemite
    sha256 "4361c01b46dc6061694e5f5a58c326efedad66ddeb7e1b063e53ff5ebb995d8a" => :mavericks
    sha256 "a8d9c8d59af854970bfffa16dc62cb584383887053a4ded39cfbbfdabac624bc" => :mountain_lion
  end

  head do
    url "https://github.com/ellson/graphviz.git"

    depends_on "automake" => :build
    depends_on "autoconf" => :build
    depends_on "libtool" => :build
  end

  # https://github.com/Homebrew/homebrew/issues/14566
  env :std

  option :universal
  option "with-bindings", "Build Perl/Python/Ruby/etc. bindings"
  option "with-pango", "Build with Pango/Cairo for alternate PDF output"
  option "with-app", "Build GraphViz.app (requires full XCode install)"
  option "with-gts", "Build with GNU GTS support (required by prism)"

  deprecated_option "with-x" => "with-x11"
  deprecated_option "with-pangocairo" => "with-pango"

  depends_on "pkg-config" => :build
  depends_on xcode: :build if build.with? "app"
  depends_on "pango" => :optional
  depends_on "gts" => :optional
  depends_on "librsvg" => :optional
  depends_on "freetype" => :optional
  depends_on x11: :optional
  depends_on "libpng"

  if build.with? "bindings"
    depends_on "swig" => :build
    depends_on :python
    depends_on :java
  end

  fails_with :clang do
    build 318
  end

  patch :p0 do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/ec8d133/graphviz/patch-project.pbxproj.diff"
    sha256 "7c8d5c2fd475f07de4ca3a4340d722f472362615a369dd3f8524021306605684"
  end

  def install
    ENV.universal_binary if build.universal?
    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --prefix=#{prefix}
      --without-qt
      --with-quartz
    ]
    args << "--with-gts" if build.with? "gts"
    args << "--disable-swig" if build.without? "bindings"
    args << "--without-pangocairo" if build.without? "pango"
    args << "--without-freetype2" if build.without? "freetype"
    args << "--without-x" if build.without? "x11"
    args << "--without-rsvg" if build.without? "librsvg"

    if build.stable? && build.with?("bindings")
      # http://www.graphviz.org/mantisbt/view.php?id=2486
      # Fixed in HEAD to use "undefined dynamic_lookup".
      inreplace "configure", 'PYTHON_LIBS="-lpython$PYTHON_VERSION_SHORT"',
                             'PYTHON_LIBS="-undefined dynamic_lookup"'
    end

    if build.head?
      system "./autogen.sh", *args
    else
      system "./configure", *args
    end
    system "make", "install"

    if build.with? "app"
      cd "macosx" do
        xcodebuild "-configuration", "Release", "SYMROOT=build", "PREFIX=#{prefix}",
                   "ONLY_ACTIVE_ARCH=YES", "MACOSX_DEPLOYMENT_TARGET=#{MacOS.version}"
      end
      prefix.install "macosx/build/Release/Graphviz.app"
    end

    (bin/"gvmap.sh").unlink
  end

  test do
    (testpath/"sample.dot").write <<-EOS.undent
    digraph G {
      a -> b
    }
    EOS

    system "#{bin}/dot", "-Tpdf", "-o", "sample.pdf", "sample.dot"
  end
end
