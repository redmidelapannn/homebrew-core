class Neko < Formula
  desc "High-level, dynamically typed programming language"
  homepage "http://nekovm.org"
  # revision includes recent parameterized build targets for mac.  Use a :tag
  # on the next release
  url "https://github.com/HaxeFoundation/neko.git", :revision => "22c49a89b56b9f106d7162710102e9475227e882"
  version "2.0.0-22c49a8"
  revision 2

  head "https://github.com/HaxeFoundation/neko.git"

  bottle do
    revision 1
    sha256 "7e236b71ffeeffbcd7b900e8eca1d918506369f04b384db636193e8fc749e60a" => :el_capitan
    sha256 "8bbf27e753c49996fd8f2cdd86781af48b06d0403edf855b7af75191b6fb314d" => :yosemite
    sha256 "2bd95d454e64a2cb01527fe6f8dc859aff9aba7fb7a2a15f39fc4bb6c1ab20bb" => :mavericks
  end

  head do
    depends_on "cmake" => :build
    depends_on "pkg-config" => :build
    depends_on "mbedtls"
  end

  depends_on "bdw-gc"
  depends_on "pcre"
  depends_on "openssl"

  def install
    if build.head?
      # Let cmake download its own copy of MariaDBConnector during build and statically link it.
      # It is because there is no easy way to define we just need any one of mariadb, mariadb-connector-c,
      # mysql, and mysql-connector-c.
      system "cmake", ".", "-DSTATIC_DEPS=MariaDBConnector", "-DRUN_LDCONFIG=OFF", *std_cmake_args
      system "make", "install"
    else
      # Build requires targets to be built in specific order
      ENV.deparallelize
      system "make", "os=osx", "LIB_PREFIX=#{HOMEBREW_PREFIX}", "INSTALL_FLAGS="

      include.install Dir["vm/neko*.h"]
      neko = lib/"neko"
      neko.install Dir["bin/*"]

      # Symlink into bin so libneko.dylib resolves correctly for custom prefix
      %w[neko nekoc nekoml nekotools].each do |file|
        bin.install_symlink neko/file
      end
      lib.install_symlink neko/"libneko.dylib"
    end
  end

  def caveats
    s = ""
    if HOMEBREW_PREFIX.to_s != "/usr/local"
      s << <<-EOS.undent
        You must add the following line to your .bashrc or equivalent:
          export NEKOPATH="#{HOMEBREW_PREFIX}/lib/neko"
        EOS
    end
    s
  end

  test do
    ENV["NEKOPATH"] = "#{HOMEBREW_PREFIX}/lib/neko"
    system "#{bin}/neko", "#{HOMEBREW_PREFIX}/lib/neko/test.n"
  end
end
