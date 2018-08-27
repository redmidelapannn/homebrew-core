class ProtobufAT25 < Formula
  desc "Protocol buffers (Google's data interchange format)"
  homepage "https://github.com/protocolbuffers/protobuf"
  url "https://github.com/protocolbuffers/protobuf/releases/download/v2.5.0/protobuf-2.5.0.tar.bz2"
  sha256 "13bfc5ae543cf3aa180ac2485c0bc89495e3ae711fc6fab4f8ffe90dfb4bb677"

  bottle do
    cellar :any
    rebuild 1
    sha256 "0f425b9a608bd6b1498172686fd14365d9c3baddb889a3e55a684526f01ae162" => :high_sierra
    sha256 "b43fef2201c7a2023f2e3a5bc393e95db97d689c69efd7b2cf074b0a525c44dd" => :sierra
    sha256 "e5409f26086e411c1a8b6463c2f8906e81869712a7fcc1004e9c2d7d9b4a7cb6" => :el_capitan
  end

  keg_only :versioned_formula

  # this will double the build time approximately if enabled
  option "with-test", "Run build-time check"
  option :cxx11

  deprecated_option "with-python" => "with-python@2"

  depends_on "python@2" => :optional

  deprecated_option "with-check" => "with-test"

  def install
    # Don't build in debug mode. See:
    # https://github.com/Homebrew/homebrew/issues/9279
    ENV.prepend "CXXFLAGS", "-DNDEBUG"
    ENV.cxx11 if build.cxx11?

    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-zlib"
    system "make"
    system "make", "check" if build.with?("test") || build.bottle?
    system "make", "install"

    # Install editor support and examples
    doc.install "editors", "examples"

    if build.with? "python@2"
      chdir "python" do
        ENV["PROTOCOL_BUFFERS_PYTHON_IMPLEMENTATION"] = "cpp"
        ENV.append_to_cflags "-I#{include}"
        ENV.append_to_cflags "-L#{lib}"
        args = Language::Python.setup_install_args libexec
        system "python", *args
      end
      site_packages = "lib/python2.7/site-packages"
      pth_contents = "import site; site.addsitedir('#{libexec/site_packages}')\n"
      (prefix/site_packages/"homebrew-protobuf.pth").write pth_contents
    end
  end

  def caveats; <<~EOS
    Editor support and examples have been installed to:
      #{doc}
  EOS
  end

  test do
    (testpath/"test.proto").write <<~EOS
      package test;
      message TestCase {
        required string name = 4;
      }
      message Test {
        repeated TestCase case = 1;
      }
    EOS
    system bin/"protoc", "test.proto", "--cpp_out=."
    if build.with? "python@2"
      protobuf_pth = lib/"python2.7/site-packages/homebrew-protobuf.pth"
      (testpath.realpath/"Library/Python/2.7/lib/python/site-packages").install_symlink protobuf_pth
      system "python", "-c", "import google.protobuf"
    end
  end
end
