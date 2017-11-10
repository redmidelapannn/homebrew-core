class Ice < Formula
  desc "Comprehensive RPC framework"
  homepage "https://zeroc.com"
  url "https://github.com/zeroc-ice/ice/archive/v3.7.0.tar.gz"
  sha256 "809fff14a88a7de1364c846cec771d0d12c72572914e6cc4fb0b2c1861c4a1ee"
  revision 1

  bottle do
    cellar :any
    rebuild 1
    sha256 "db304ad4c5db9e702051b71f4b6636e1cb2d297eb51bb38f164d699e9e9733ec" => :high_sierra
    sha256 "bfb3113977da711b5c8e39911f0c614d939ac074b24d5826c56894048d88586a" => :sierra
    sha256 "fc5a4c020010b31b30d544a989249400fd1cffa73167a54acb16ca247cafeafe" => :el_capitan
  end

  # Xcode 9 support
  patch do
    url "https://github.com/zeroc-ice/ice/commit/3a55ebb51b8914b60d308a0535d9abf97567138d.patch?full_index=1"
    sha256 "d95e76acebdae69edf3622f5141ea32bbbd5844be7c29d88e6e985d14a5d5dd4"
  end

  #
  # NOTE: we don't build slice2py, slice2js, slice2rb by default to prevent clashes with
  # the translators installed by the PyPI/GEM/npm packages.
  #

  option "with-additional-compilers", "Build additional Slice compilers (slice2py, slice2js, slice2rb)"
  option "with-java", "Build Ice for Java and the IceGrid GUI app"
  option "without-python", "Build without Ice for Python"
  option "without-xcode-sdk", "Build without the Xcode SDK for iOS development (includes static libs)"

  depends_on "mcpp"
  depends_on "lmdb"
  depends_on :java => ["1.8+", :optional]
  depends_on :macos => :mavericks
  depends_on :python if MacOS.version <= :snow_leopard

  def install
    # Ensure Gradle uses a writable directory even in sandbox mode
    ENV["GRADLE_USER_HOME"] = "#{buildpath}/.gradle"

    args = [
      "prefix=#{prefix}",
      "V=1",
      "MCPP_HOME=#{Formula["mcpp"].opt_prefix}",
      "LMDB_HOME=#{Formula["lmdb"].opt_prefix}",
      "CONFIGS=shared cpp11-shared #{build.with?("xcode-sdk") ? "xcodesdk cpp11-xcodesdk" : ""}",
      "PLATFORMS=all",
      "SKIP=slice2confluence #{build.without?("python") ? "slice2py" : ""} #{build.without?("additional-compilers") ? "slice2rb slice2js" : ""}",
      "LANGUAGES=cpp objective-c #{build.with?("java") ? "java java-compat" : ""} #{build.with?("python") ? "python" : ""}",
    ]

    if build.with? "python"
      args << "PYTHON_LIB_NAME=-Wl,-undefined,dynamic_lookup"
      cd "python" do
        inreplace "config/install_dir", "print(e.install_dir)", "print('#{lib}/python2.7/site-packages')"
        inreplace "config/Make.rules", /^python_ldflags\s*:=\s*-L\$\(PYTHON_LIB_DIR\) -l\$\(PYTHON_LIB_NAME\)$/, "python_ldflags := -Wl,-undefined,dynamic_lookup"
      end

      # If building Python support, slice2py is required to generate Python code from slices. However if additional
      # compilers should not be installed, we must skip installation of slice2py
      # => patch Makefile macro `define create-translator-project`
      if build.without?("additional-compilers")
        inreplace "config/Make.project.rules",
                  /(define create-translator-project.*?\$1_install_platforms\s*:=.*?)endef/m,
                  "\\1\n" \
                  "ifeq ($(notdir $1),slice2py)\n" \
                  "$1_install_platforms := \n" \
                  "endif\n" \
                  "endef"
      end
    end

    system "make", "install", *args
  end

  test do
    (testpath / "Hello.ice").write <<~EOS
      module Test
      {
          interface Hello
          {
              void sayHello();
          }
      }
    EOS
    (testpath / "Test.cpp").write <<~EOS
      #include <Ice/Ice.h>
      #include <Hello.h>

      class HelloI : public Test::Hello
      {
      public:
        virtual void sayHello(const Ice::Current&) override {}
      };

      int main(int argc, char* argv[])
      {
        Ice::CommunicatorHolder ich(argc, argv);
        auto adapter = ich->createObjectAdapterWithEndpoints("Hello", "default -h localhost -p 10000");
        adapter->add(std::make_shared<HelloI>(), Ice::stringToIdentity("hello"));
        adapter->activate();
        return 0;
      }
    EOS
    system "#{bin}/slice2cpp", "Hello.ice"
    system ENV.cxx, "-DICE_CPP11_MAPPING", "-std=c++11", "-c", "-I#{include}", "-I.", "Hello.cpp"
    system ENV.cxx, "-DICE_CPP11_MAPPING", "-std=c++11", "-c", "-I#{include}", "-I.", "Test.cpp"
    system ENV.cxx, "-L#{lib}", "-o", "test", "Test.o", "Hello.o", "-lIce++11"
    system "./test"
  end
end
