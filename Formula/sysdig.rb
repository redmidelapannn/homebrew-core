class Sysdig < Formula
  desc "System-level exploration and troubleshooting tool"
  homepage "https://sysdig.com/"
  url "https://github.com/draios/sysdig/archive/0.26.6.tar.gz"
  sha256 "d215d9b5835db6eec0dc6f0bac96552fd8bd7c71d3d6ed482423cdddd5b1c93e"

  bottle do
    sha256 "32fc0cee25fca19b952b8c1a11219cd59dab2013992b0c5b2a4ca7feb7b22816" => :catalina
    sha256 "a964eb57a5bd04f1792100071f899f3d2e95770ae876218c6e7c489e1d79caa3" => :mojave
    sha256 "12bc39b5b5f83ac30f20ca341b12cc1f4b47ac4c702446ac28c9d4a5e29b021a" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "jsoncpp"
  depends_on "luajit"
  depends_on "tbb"

  # More info on https://gist.github.com/juniorz/9986999
  resource "sample_file" do
    url "https://gist.githubusercontent.com/juniorz/9986999/raw/a3556d7e93fa890a157a33f4233efaf8f5e01a6f/sample.scap"
    sha256 "efe287e651a3deea5e87418d39e0fe1e9dc55c6886af4e952468cd64182ee7ef"
  end

  def install
    mkdir "build" do
      system "cmake", "..", "-DSYSDIG_VERSION=#{version}",
                            "-DUSE_BUNDLED_DEPS=OFF",
                            "-DCREATE_TEST_TARGETS=OFF",
                            *std_cmake_args
      system "make"
      system "make", "install"
    end

    (pkgshare/"demos").install resource("sample_file").files("sample.scap")
  end

  test do
    output = shell_output("#{bin}/sysdig -r #{pkgshare}/demos/sample.scap")
    assert_match "/tmp/sysdig/sample", output
  end
end
