class Gperftools < Formula
  desc "Multi-threaded malloc() and performance analysis tools"
  homepage "https://github.com/gperftools/gperftools"
  revision 1
  head "https://github.com/gperftools/gperftools.git"

  stable do
    url "https://github.com/gperftools/gperftools/releases/download/gperftools-2.5/gperftools-2.5.tar.gz"
    sha256 "6fa2748f1acdf44d750253e160cf6e2e72571329b42e563b455bde09e9e85173"

    # Fix finding default zone on macOS Sierra (https://github.com/gperftools/gperftools/issues/827)
    patch do
      url "https://github.com/gperftools/gperftools/commit/acac6af26b0ef052b39f61a59507b23e9703bdfa.patch?full_index=1"
      sha256 "164b99183c9194706670bec032bb96d220ce27fc5257b322d994096516133376"
    end

    # Prevents build failure on Xcode >= 7.3:
    # Undefined symbols for architecture x86_64:
    #   "operator delete(void*, unsigned long)", referenced from:
    #     ProcMapsIterator::~ProcMapsIterator() in libsysinfo.a(sysinfo.o)
    # Reported 17 April 2016: gperftools/gperftools#794
    patch do
      url "https://raw.githubusercontent.com/Homebrew/formula-patches/edb49c752c0c02eb9e47bd2ab9788d504fd5b495/gperftools/revert-sized-delete-aliases.patch"
      sha256 "49eb4f2ac52ad38723d3bf371e7d682644ef09ee7c1e2e2098e69b6c085153b6"
    end
  end

  bottle do
    cellar :any
    rebuild 1
    sha256 "068f2437036caf5298abe0b722f11133868d5a2a7042a7334bb00778124a5eba" => :sierra
    sha256 "767dd94d7b96c68c9ef075acfb18d6ef45299bbbbd6979dc288a37c396b586fd" => :el_capitan
    sha256 "fac2417b85738b05ca87e24420fb7732ff4ef6eeb00463333a90f7571c2c8ed0" => :yosemite
  end

  # Needed for stable due to the patch; otherwise, just head
  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  def install
    ENV.append_to_cflags "-D_XOPEN_SOURCE"

    # Needed for stable due to the patch; otherwise, just head
    system "autoreconf", "-fiv"

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<-EOS.undent
      #include <assert.h>
      #include <gperftools/tcmalloc.h>

      int main()
      {
        void *p1 = tc_malloc(10);
        assert(p1 != NULL);

        tc_free(p1);

        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-ltcmalloc", "-o", "test"
    system "./test"
  end
end
