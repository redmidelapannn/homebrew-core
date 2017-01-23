class Ydk < Formula
  desc "generate API bindings to YANG data models"
  homepage "https://github.com/CiscoDevNet/ydk-cpp"
  url "https://github.com/CiscoDevNet/ydk-cpp/archive/0.5.2.tar.gz"
  sha256 "39ca26b57e0d784243ebd0c07eb0e35fc0ad8600886fde2be4440eae898b844d"

  bottle do
    cellar :any_skip_relocation
    sha256 "a2b68f0f824c1dfe8af5325ecb0f718c5af33f807d6e2f1a168f96017aca4329" => :sierra
    sha256 "3ee533df6b2898aa7fe0737668d34f8af3acc077ab6da05fa95732bbe0a5b1e4" => :el_capitan
    sha256 "73dd2953791b049238b36661ef3f79fd34c5f82b3efa28b96e35105a45622019" => :yosemite
  end

  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "boost-python"
  depends_on "curl"
  depends_on "libssh"
  depends_on "pcre"
  depends_on "xml2"
  depends_on "pkg-config" => :build
  depends_on :x11 => :optional

  def install
    cd "core/ydk" do
      mkdir("build")
      cd "build" do
        system "cmake", "..", *std_cmake_args
        system "make", "install"
      end
    end
  end

  test do
    (testpath/"test.cpp").write <<-EOS.undent
      #include <ydk/path_api.hpp>
      int main() {
        ydk::path::Repository repo{};
        return 0;
      }
    EOS
    system ENV.cxx, "-std=c++11", "-Wall", "-Wextra", "-g", "-O0", "test.cpp", "-otest",
    "-lboost_log_setup-mt", "-lboost_log-mt", "-lboost_thread-mt", "-lboost_date_time-mt",
    "-lboost_system-mt", "-lboost_filesystem-mt", "-lboost_log_setup-mt", "-lboost_log-mt",
    "-lboost_thread-mt", "-lboost_date_time-mt", "-lboost_system-mt", "-lboost_filesystem-mt",
    "-lboost_log_setup-mt", "-lboost_log-mt", "-lboost_filesystem-mt", "-lboost_system-mt",
    "-lxml2", "-lcurl", "-lssh_threads", "-lpcre", "-lxslt", "-lssh", "-lpthread", "-ldl", "-lydk"
    system "./test"
  end
end
