class CodesignRequirement < Requirement
  include FileUtils
  fatal true

  satisfy(:build_env => false) do
    mktemp do
      cp "/usr/bin/false", "llvm_check"
      quiet_system "/usr/bin/codesign", "-f", "-s", "lldb_codesign", "--dryrun", "llvm_check"
    end
  end

  def message
    <<-EOS.undent
      lldb_codesign identity must be available to build with LLDB.
      See: https://llvm.org/svn/llvm-project/lldb/trunk/docs/code-signing.txt
    EOS
  end
end

class Llvm < Formula
  desc "Next-gen compiler infrastructure"
  homepage "http://llvm.org/"

  stable do
    url "http://llvm.org/releases/3.8.0/llvm-3.8.0.src.tar.xz"
    sha256 "555b028e9ee0f6445ff8f949ea10e9cd8be0d084840e21fbbe1d31d51fc06e46"

    resource "clang" do
      url "http://llvm.org/releases/3.8.0/cfe-3.8.0.src.tar.xz"
      sha256 "04149236de03cf05232d68eb7cb9c50f03062e339b68f4f8a03b650a11536cf9"
    end

    resource "clang-extra-tools" do
      url "http://llvm.org/releases/3.8.0/clang-tools-extra-3.8.0.src.tar.xz"
      sha256 "afbda810106a6e64444bc164b921be928af46829117c95b996f2678ce4cb1ec4"
    end

    resource "compiler-rt" do
      url "http://llvm.org/releases/3.8.0/compiler-rt-3.8.0.src.tar.xz"
      sha256 "c8d3387e55f229543dac1941769120f24dc50183150bf19d1b070d53d29d56b0"
    end

    # only required to build and run Compiler-RT tests on OS X, optional otherwise. clang.llvm.org/get_started.html
    resource "libcxx" do
      url "http://llvm.org/releases/3.8.0/libcxx-3.8.0.src.tar.xz"
      sha256 "36804511b940bc8a7cefc7cb391a6b28f5e3f53f6372965642020db91174237b"
    end

    resource "libcxxabi" do
      url "http://llvm.org/releases/3.8.0/libcxxabi-3.8.0.src.tar.xz"
      sha256 "c5ee0871aff6ec741380c4899007a7d97f0b791c81df69d25b744eebc5cee504"
    end

    resource "libunwind" do
      url "http://llvm.org/releases/3.8.0/libunwind-3.8.0.src.tar.xz"
      sha256 "af3eaf39ecdc3b9e89863fb62e1aa3c135cfde7e9415424e4e396d7486a9422b"
    end

    resource "lld" do
      url "http://llvm.org/releases/3.8.0/lld-3.8.0.src.tar.xz"
      sha256 "94704dda228c9f75f4403051085001440b458501ec97192eee06e8e67f7f9f0c"
    end

    resource "lldb" do
      url "http://llvm.org/releases/3.8.0/lldb-3.8.0.src.tar.xz"
      sha256 "e3f68f44147df0433e7989bf6ed1c58ff28d7c68b9c47553cb9915f744785a35"
    end

    resource "openmp" do
      url "http://llvm.org/releases/3.8.0/openmp-3.8.0.src.tar.xz"
      sha256 "92510e3f62e3de955e3a0b6708cebee1ca344d92fb02369cba5fdd5c68f773a0"
    end

    resource "polly" do
      url "http://llvm.org/releases/3.8.0/polly-3.8.0.src.tar.xz"
      sha256 "84cbabc0b6a10a664797907d291b6955d5ea61aef04e3f3bb464e42374d1d1f2"
    end
  end

  bottle do
    cellar :any
    revision 2
    sha256 "3b4b2c50e018125c0fa7aa9a14e8066b301afa6ebe2c36a198962e4c9af318a7" => :el_capitan
    sha256 "382eb51bb69c52fb3800c0498d1c6799b9046af8413be15217fc58effc9963b3" => :yosemite
    sha256 "57f2bb04233429051ff77deeaf74612c2d56be5d6bc13d1c6f8457cd057bc9e7" => :mavericks
  end

  head do
    url "http://llvm.org/git/llvm.git"

    resource "clang" do
      url "http://llvm.org/git/clang.git"
    end

    resource "clang-extra-tools" do
      url "http://llvm.org/git/clang-tools-extra.git"
    end

    resource "compiler-rt" do
      url "http://llvm.org/git/compiler-rt.git"
    end

    resource "libcxx" do
      url "http://llvm.org/git/libcxx.git"
    end

    resource "libcxxabi" do
      url "http://llvm.org/git/libcxxabi.git"
    end

    resource "libunwind" do
      url "git://git.sv.gnu.org/libunwind.git"
    end

    resource "lld" do
      url "http://llvm.org/git/lld.git"
    end

    resource "lldb" do
      url "http://llvm.org/git/lldb.git"
    end

    resource "polly" do
      url "http://llvm.org/git/polly.git"
    end
  end

  keg_only :provided_by_osx

  option :universal
  option "without-clang", "Do not build the Clang compiler and support libraries"
  option "without-clang-extra-tools", "Do not build extra tools for Clang"
  option "without-compiler-rt", "Do not build Clang runtime support libraries for code sanitizers, builtins, and profiling"
  option "without-libcxx", "Do not build the libc++ standard library"
  option "with-libcxxabi", "Build the libc++abi standard library"
  option "with-libunwind", "Build the libunwind library"
  option "without-lld", "Do not build LLD linker"
  option "with-lldb", "Build LLDB debugger"
  option "without-openmp", "Build without the additional OpenMP Runtime Libraries"
  option "with-python", "Build Python bindings against Homebrew Python"
  option "without-rtti", "Build without C++ RTTI"
  option "without-utils", "Do not install utility binaries"
  option "without-polly", "Build without Polly optimizer"
  option "with-test", "Build LLVM unit tests"
  option "with-shared-libs", "Build shared instead of static libraries"
  option "without-libffi", "Use libffi to call external functions from the interpreter"
  option "with-all-targets", "Build all targets rather than just AMDGPU, ARM, NVPTX, and X86"

  depends_on "libffi" => :recommended # llvm.org/docs/GettingStarted.grml#requirements
  depends_on "graphviz" => :optional # for the 'dot' tool (lldb)
  depends_on "ocaml" => :optional

  if build.with? "python"
    depends_on "python"
  elsif MacOS.version <= :snow_leopard
    depends_on :python
  else
    depends_on :python => :optional # not sure this is correct
  end
  depends_on "cmake" => :build

  if build.with? "lldb"
    depends_on "swig" if MacOS.version >= :lion
    depends_on CodesignRequirement
  end

  # Apple's libstdc++ is too old to build LLVM
  fails_with :llvm
  # According to the official llvm readme, GCC 4.7+ is required
  fails_with :gcc_4_0
  fails_with :gcc
  ("4.3".."4.6").each do |n|
    fails_with :gcc => n
  end

  def build_libcxx
    build.with?("libcxx") || (build.with?("clang") && !MacOS::CLT.installed?)
  end

  def install
    # Apple's libstdc++ is too old to build LLVM
    ENV.libcxx if ENV.compiler == :clang

    (buildpath/"tools/clang").install resource("clang") if build.with? "clang"

    if build.with? "clang-extra-tools"
      odie "--with-extra-tools requires --with-clang" if build.without? "clang"
      (buildpath/"tools/clang/tools/extra").install resource("clang-extra-tools")
    end

    (buildpath/"projects/libcxx").install resource("libcxx") if build_libcxx
    (buildpath/"tools/lld").install resource("lld") if build.with? "lld"
    ["libcxxabi", "libunwind", "openmp"].each do |r|
      (buildpath/"projects"/r).install resource(r) if build.with? r
    end

    if build.with? "lldb"
      odie "--with-lldb requires --with-clang" if build.without? "clang"
      (buildpath/"tools/lldb").install resource("lldb")

      # Building lldb requires a code signing certificate.
      # The instructions provided by llvm creates this certificate in the
      # user's login keychain. Unfortunately, the login keychain is not in
      # the search path in a superenv build. The following three lines add
      # the login keychain to ~/Library/Preferences/com.apple.security.plist,
      # which adds it to the superenv keychain search path.
      mkdir_p "#{ENV["HOME"]}/Library/Preferences"
      username = ENV["USER"]
      system "security", "list-keychains", "-d", "user", "-s", "/Users/#{username}/Library/Keychains/login.keychain"
    end

    if build.with? "polly"
      odie "--with-polly requires --with-clang" if build.without? "clang"
      (buildpath/"tools/polly").install resource("polly")
    end

    if build.with? "compiler-rt"
      odie "--with-compiler-rt requires --with-clang" if build.without? "clang"
      (buildpath/"projects/compiler-rt").install resource("compiler-rt")

      # compiler-rt has some iOS simulator features that require i386 symbols
      # I'm assuming the rest of clang needs support too for 32-bit compilation
      # to work correctly, but if not, perhaps universal binaries could be
      # limited to compiler-rt. llvm makes this somewhat easier because compiler-rt
      # can almost be treated as an entirely different build from llvm.
      ENV.permit_arch_flags
    end

    args = %w[
      -DLLVM_OPTIMIZED_TABLEGEN=ON
    ]
    args << "-DLLVM_TARGETS_TO_BUILD=#{build.with?("all-targets") ? "all" : "AMDGPU;ARM;NVPTX;X86"}"
    args << "-DLLVM_BUILD_LLVM_DYLIB=ON" if build.without? "shared-libs"
    args << "-DBUILD_SHARED_LIBS=ON" if build.with? "shared-libs"
    args << "-DLLVM_BUILD_EXTERNAL_COMPILER_RT=ON" if build.with? "compiler-rt"
    if build.with? "test"
      args << "-DLLVM_BUILD_TESTS=ON"
      args << "-DLLVM_ABI_BREAKING_CHECKS=ON"
    end
    args << "-DLLVM_ENABLE_RTTI=ON" if build.with? "rtti"
    args << "-DLLVM_INSTALL_UTILS=ON" if build.with? "utils"
    args << "-DLLVM_ENABLE_LIBCXX=ON" if build_libcxx
    args << "-DLLVM_ENABLE_LIBCXXABI=ON" if build.with? "libcxxabi"
    # args << "-DLLVM_ENABLE_DOXYGEN=ON" if build.with? "doxygen"

    if build.with? "openmp"
      args << "-DLIBOMP_ENABLE_SHARED=ON" if build.with? "shared-libs"
      args << "-DLIBOMP_ARCH=x86_64"
    end

    if build.with? "libffi"
      args << "-DLLVM_ENABLE_FFI=ON"
      args << "-DFFI_INCLUDE_DIR=#{Formula["libffi"].opt_lib}/libffi-#{Formula["libffi"].version}/include"
      args << "-DFFI_LIBRARY_DIR=#{Formula["libffi"].opt_lib}"
    end

    if build.universal?
      ENV.permit_arch_flags
      args << "-DCMAKE_OSX_ARCHITECTURES=#{Hardware::CPU.universal_archs.as_cmake_arch_flags}"
    end

    if build.with? "polly"
      args << "-DWITH_POLLY=ON"
      args << "-DLINK_POLLY_INTO_TOOLS=ON"
    end

    mktemp do
      system "cmake", "-G", "Unix Makefiles", buildpath, *(std_cmake_args + args)
      system "make"
      system "make", "install"
    end

    if build.with? "clang"
      (share/"clang/tools").install Dir["tools/clang/tools/scan-{build,view}"]
      if build.head?
        # inreplace "#{share}/clang/tools/scan-build/bin/scan-build", "$RealBin/bin/clang", "#{bin}/clang"
        bin.install_symlink share/"clang/tools/scan-build/bin/scan-build", share/"clang/tools/scan-view/bin/scan-view"
        man1.install_symlink share/"clang/tools/scan-build/man/scan-build.1"
      else
        # inreplace "#{share}/clang/tools/scan-build/scan-build", "$RealBin/bin/clang", "#{bin}/clang"
        bin.install_symlink share/"clang/tools/scan-build/scan-build", share/"clang/tools/scan-view/scan-view"
        man1.install_symlink share/"clang/tools/scan-build/scan-build.1"
      end
    end

    # install llvm python bindings
    (lib/"python2.7/site-packages").install buildpath/"bindings/python/llvm"
    (lib/"python2.7/site-packages").install buildpath/"tools/clang/bindings/python/clang" if build.with? "clang"
  end

  def caveats
    s = <<-EOS.undent
      LLVM executables are installed in #{opt_bin}.
      Extra tools are installed in #{opt_pkgshare}.
    EOS

    if build.with? "libcxx"
      s += <<-EOS.undent
        To use the bundled libc++ please add the following LDFLAGS:
          LDFLAGS="-L#{opt_lib} -lc++"
      EOS
    end

    s
  end

  test do
    assert_equal prefix.to_s, shell_output("#{bin}/llvm-config --prefix").chomp

    if build.with? "clang"
      (testpath/"test.cpp").write <<-EOS.undent
        #include <iostream>
        using namespace std;

        int main()
        {
          cout << "Hello World!" << endl;
          return 0;
        }
      EOS

      # test xcode
      # test clt
      # set libcxx

      if MacOS::CLT.installed?
        system "#{bin}/clang++", "-v", "-std=c++11", "-stdlib=libc++", "test.cpp", "-o", "test"
        system "./test"
      end

      if build_libcxx
        system "#{bin}/clang++", "-v", "-std=c++11", "-stdlib=libc++", "-nostdinc++", "-I#{include}/c++/v1", "-L#{lib}", "-Wl,-rpath,#{lib}", "test.cpp", "-o", "test"
        system "./test"
      end

    end
  end
end
