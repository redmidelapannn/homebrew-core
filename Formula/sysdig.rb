class Sysdig < Formula
  desc "System-level exploration and troubleshooting tool"
  homepage "https://www.sysdig.org/"
  url "https://github.com/draios/sysdig/archive/0.25.tar.gz"
  sha256 "4ab2d3cebb49e3b059bf974d68cef4cedc141d1544fa2b252cfa1cdf3ee33fdd"

  bottle do
    sha256 "bdf18ed46f1588b2cbdf7150b4b11e127e2aa6953ac1f7ab430d3121ad8b71dc" => :mojave
    sha256 "db6e17dca4dfc8eed6623f3ac74b07fa68e17f1d2a44f03fb50c2e55ea4d44e7" => :high_sierra
    sha256 "9ecf50e505788ab821b3da8856399059e67ae5c8ca1eb91e1e3ac519063afce0" => :sierra
  end

  depends_on "cmake" => :build
  depends_on "jsoncpp"
  depends_on "luajit"
  depends_on "openssl"

  # More info on https://gist.github.com/juniorz/9986999
  resource "sample_file" do
    url "https://gist.githubusercontent.com/juniorz/9986999/raw/a3556d7e93fa890a157a33f4233efaf8f5e01a6f/sample.scap"
    sha256 "efe287e651a3deea5e87418d39e0fe1e9dc55c6886af4e952468cd64182ee7ef"
  end

  def install
    mkdir "build" do
      system "cmake", "..", "-DSYSDIG_VERSION=#{version}",
                            "-DUSE_BUNDLED_DEPS=OFF",
                            *std_cmake_args
      system "make", "install"
    end

    (pkgshare/"demos").install resource("sample_file").files("sample.scap")
  end

  test do
    output = shell_output("#{bin}/sysdig -r #{pkgshare}/demos/sample.scap")
    assert_match "/tmp/sysdig/sample", output
  end
end
