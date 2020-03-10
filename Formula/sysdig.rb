class Sysdig < Formula
  desc "System-level exploration and troubleshooting tool"
  homepage "https://sysdig.com/"
  # The version used here should be the latest stable version from:
  # https://github.com/draios/sysdig/releases/latest
  url "https://github.com/draios/sysdig/archive/0.26.5.tar.gz"
  sha256 "3a251eca408e71df9582eac93632d8927c5abcc8d09b25aa32ef6d9c99a07bd4"

  bottle do
    rebuild 1
    sha256 "f23330fcf5081f29a7a57ec7e119c547738eab094f82abca85953af46145da2d" => :catalina
    sha256 "9196b4c6b63b6debf2fe94b5b1e3a3044f2a6422e22c4adcab8b0515fc608882" => :mojave
    sha256 "f5a0324e3e82954ac6ec9dfe1cbef70eaa240d9a1f5c32ccdb7916ed12a85d35" => :high_sierra
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
