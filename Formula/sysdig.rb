class Sysdig < Formula
  desc "System-level exploration and troubleshooting tool"
  homepage "https://www.sysdig.org/"
  url "https://github.com/draios/sysdig/archive/0.16.0.tar.gz"
  sha256 "73a0190c973e4a591013d0c73ff2ea9f623ab50b78ff78f7a33fe31460ba24a1"

  bottle do
    rebuild 1
    sha256 "ea71ac5b6c7f1567041bc9de8d73ffd19106aa6dbb7d4a6ee035b86461706578" => :sierra
    sha256 "eaa1eee1d4fff9fbe7e2c1488e7acdddce9b6a20477679d17093f129eb664232" => :el_capitan
    sha256 "785427fee2c68df5b48a7c4300f4cfe3f2ccfb76847c3cdd90cdd3570d2a0712" => :yosemite
  end

  depends_on "cmake" => :build
  depends_on "jsoncpp"
  depends_on "luajit"

  # More info on https://gist.github.com/juniorz/9986999
  resource "sample_file" do
    url "https://gist.githubusercontent.com/juniorz/9986999/raw/a3556d7e93fa890a157a33f4233efaf8f5e01a6f/sample.scap"
    sha256 "efe287e651a3deea5e87418d39e0fe1e9dc55c6886af4e952468cd64182ee7ef"
  end

  def install
    ENV.libcxx if MacOS.version < :mavericks

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
