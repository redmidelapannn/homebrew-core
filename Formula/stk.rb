class Stk < Formula
  desc "Sound Synthesis Toolkit"
  homepage "https://ccrma.stanford.edu/software/stk/"
  url "https://ccrma.stanford.edu/software/stk/release/stk-4.5.0.tar.gz"
  sha256 "619f1a0dee852bb2b2f37730e2632d83b7e0e3ea13b4e8a3166bf11191956ee3"

  bottle do
    cellar :any_skip_relocation
    rebuild 2
    sha256 "de94e6b6d318f42d3f5e37568d41a5b6cf882aad35c3865d37bb3234d4d6236b" => :sierra
    sha256 "f35a522de4ab0d674bdaa120527abcbc545462d81bd13439e5262c0fe7823716" => :el_capitan
    sha256 "880303113e0aa832b8810b02548c1b35efe6eb943680178083a6fbd8ddedcdd7" => :yosemite
  end

  option "with-debug", "Compile with debug flags and modified CFLAGS for easier debugging"

  deprecated_option "enable-debug" => "with-debug"

  fails_with :clang do
    build 421
    cause "due to configure file this application will not properly compile with clang"
  end

  def install
    # Allow pre-10.9 clangs to build in C++11 mode
    ENV.libcxx
    args = %W[--prefix=#{prefix}]

    if build.with? "debug"
      inreplace "configure", 'CFLAGS="-g -O2"', 'CFLAGS="-g -O0"'
      inreplace "configure", 'CXXFLAGS="-g -O2"', 'CXXFLAGS="-g -O0"'
      inreplace "configure", 'CPPFLAGS="$CPPFLAGS $cppflag"', ' CPPFLAGS="$CPPFLAGS $cppflag -g -O0"'
      args << "--enable-debug"
    else
      args << "--disable-debug"
    end

    system "./configure", *args
    system "make"

    lib.install "src/libstk.a"
    bin.install "bin/treesed"

    (include/"stk").install Dir["include/*"]
    doc.install Dir["doc/*"]
    pkgshare.install "src", "projects", "rawwaves"
  end

  def caveats; <<-EOS.undent
    The header files have been put in a standard search path, it is possible to use an include statement in programs as follows:

      #include \"stk/FileLoop.h\"
      #include \"stk/FileWvOut.h\"

    src/ projects/ and rawwaves/ have all been copied to #{opt_pkgshare}
    EOS
  end
end
