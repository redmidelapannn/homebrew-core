class Uhd < Formula
  desc "Hardware driver for all USRP devices"
  homepage "https://files.ettus.com/manual/"
  url "https://github.com/EttusResearch/uhd/archive/v3.14.1.1.tar.gz"
  sha256 "8cbcb22d12374ceb2859689b1d68d9a5fa6bd5bd82407f66952863d5547d27d0"
  head "https://github.com/EttusResearch/uhd.git"

  bottle do
    sha256 "f3bdfaa789382c52bff7166c85fc3b96976401a805573068a32aabce156cba4c" => :mojave
    sha256 "d5e99a14fd3381f6d8c47a86b52f02e28b61e0748463a53e50e94ca45b5f99f6" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "doxygen" => :build
  depends_on "boost"
  depends_on "libusb"
  depends_on "python"

  resource "Mako" do
    url "https://files.pythonhosted.org/packages/b0/3c/8dcd6883d009f7cae0f3157fb53e9afb05a0d3d33b3db1268ec2e6f4a56b/Mako-1.1.0.tar.gz"
    sha256 "a36919599a9b7dc5d86a7a8988f23a9a3a3d083070023bab23d64f7f1d1e0a4b"
  end

  def install
    xy = Language::Python.major_minor_version "python3"
    ENV.prepend_create_path "PYTHONPATH", libexec/"vendor/lib/python#{xy}/site-packages"

    resource("Mako").stage do
      system "python3", *Language::Python.setup_install_args(libexec/"vendor")
    end

    mkdir "host-build" do
      system "cmake", "../host", *std_cmake_args, "-DENABLE_PYTHON3=ON", "-DENABLE_STATIC_LIBS=ON"
      system "make"
      system "make", "test"
      system "make", "install"
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/uhd_config_info --version")
  end
end
