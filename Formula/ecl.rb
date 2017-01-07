class Ecl < Formula
  desc "Embeddable Common Lisp"
  homepage "https://common-lisp.net/project/ecl/"
  url "https://common-lisp.net/project/ecl/static/files/release/ecl-16.1.3.tgz"
  sha256 "76a585c616e8fa83a6b7209325a309da5bc0ca68e0658f396f49955638111254"

  head "https://gitlab.com/embeddable-common-lisp/ecl.git"

  bottle do
    sha256 "cb82bfff62a67128eae09e7ec4788b8e59f50b0f30ddabf76554687e6b93d309" => :sierra
    sha256 "46e080fa46fb2e33707a6e55738118bd7112d66bf16866c90f7d5924db66324f" => :el_capitan
    sha256 "9c9a60216a28fee9ba5b7942772862bc475bd461098aa9ca593e00821016dc95" => :yosemite
  end

  depends_on "gmp"
  depends_on "bdw-gc"

  def install
    # These environment variables are necessary or gmp / boehmgc won't be found
    # No idea why
    gmp = Formula["gmp"]
    boehmgc = Formula["boehmgc"]
    ENV.append "CFLAGS", "-I#{gmp.opt_include} -I#{boehmgc.opt_include}"
    ENV.append "CXXFLAGS", "-I#{gmp.opt_include} -I#{boehmgc.opt_include}"
    ENV.append "LDFLAGS", "-L#{gmp.opt_lib} -L#{boehmgc.opt_lib}"

    # FIXME: Remove deparallelize after:
    # https://gitlab.com/embeddable-common-lisp/ecl/issues/339
    #
    # @dkochmanski notes:
    #
    # This branch is not tested and may break some unusual builds. Parallels
    # are the only (known and confirmed) issue with the build scripts in the
    # release, while the recent changes are not widely tested and may break
    # some unusual builds. If you are interested in using it, here is the
    # mentioned branch:
    #
    # https://gitlab.com/embeddable-common-lisp/ecl/tree/revert-make-split
    ENV.deparallelize

    system "./configure",
      # @MikeMcQuaid requested that I do it like this rather than ENV.append,
      # above but it breaks the build.
      # Really should be able to find depends_on libraries without further ado
      # but here we are.
                          # "CFLAGS=-I'#{gmp.opt_include} -I#{boehmgc.opt_include}'",
                          # "CXXFLAGS=-I'#{gmp.opt_include} -I#{boehmgc.opt_include}'",
                          # "LDFLAGS=-L'#{gmp.opt_lib} -L#{boehmgc.opt_lib}'",
                          "--prefix=#{prefix}",
                          "--enable-threads=yes",
                          "--with-dffi=included",
                          "--with-cxx",
                          "--enable-gmp=system"
    system "make"
    system "make", "install"
    # make check
    # Doesn't work but doesn't fail the build
    # But the real issue is 'make check' should be able to run before 'make
    # install'
    # https://gitlab.com/embeddable-common-lisp/ecl/issues/342
    # FIXME
    #
    # ==> make check
    # cd build && /Applications/Xcode.app/Contents/Developer/usr/bin/make check
    # TESTS=""
    # dyld: Library not loaded: @libdir@/libecl.16.1.dylib
    #   Referenced from: /usr/local/Cellar/ecl/16.1.3//bin/ecl
    #     Reason: image not found
    system "make", "check"
  end

  # FIXME
  # Should be 'make check', but see above
  test do
    (testpath/"simple.cl").write <<-EOS.undent
      (write-line (write-to-string (+ 2 2)))
    EOS
    assert_equal "4", shell_output("#{bin}/ecl -shell #{testpath}/simple.cl").chomp
  end
end
