class Neko < Formula
  desc "High-level, dynamically typed programming language"
  homepage "http://nekovm.org"

  head "https://github.com/HaxeFoundation/neko.git"

  stable do
    url "http://nekovm.org/media/neko-2.1.0-src.tar.gz"
    sha256 "0c93d5fe96240510e2d1975ae0caa9dd8eadf70d916a868684f66a099a4acf96"

    patch do
      # To workaround issue https://github.com/HaxeFoundation/neko/issues/130
      # It is a commit already applied to the upstream.
      url "https://github.com/HaxeFoundation/neko/commit/a8c71ad97faaccff6c6e9e09eba2d5efd022f8dc.patch?full_index=1"
      sha256 "a5d08e5ff2f6372c780d2864b699aae714fc37d4ab987cea11764082757ddb39"
    end
  end

  bottle do
    cellar :any
    rebuild 1
    sha256 "2192a818e376f8d0de41659e2b8ba71551e4b1ce36c48a228c8468d3d83d9e59" => :high_sierra
    sha256 "758f33ae789d2614c81d40e30df811293ffee157cb00aca99a22907bae767455" => :sierra
    sha256 "88b364906b11ad1c9a9913792e89509a436f6715af64b795c478e4a2f14c96e6" => :el_capitan
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "mbedtls"
  depends_on "bdw-gc"
  depends_on "pcre"
  depends_on "openssl"

  def install
    # Let cmake download its own copy of MariaDBConnector during build and statically link it.
    # It is because there is no easy way to define we just need any one of mariadb, mariadb-connector-c,
    # mysql, and mysql-connector-c.
    system "cmake", ".", "-DSTATIC_DEPS=MariaDBConnector", "-DRELOCATABLE=OFF", "-DRUN_LDCONFIG=OFF", *std_cmake_args
    system "make", "install"
  end

  def caveats
    s = ""
    if HOMEBREW_PREFIX.to_s != "/usr/local"
      s << <<~EOS
        You must add the following line to your .bashrc or equivalent:
          export NEKOPATH="#{HOMEBREW_PREFIX}/lib/neko"
        EOS
    end
    s
  end

  test do
    ENV["NEKOPATH"] = "#{HOMEBREW_PREFIX}/lib/neko"
    system "#{bin}/neko", "-version"
  end
end
