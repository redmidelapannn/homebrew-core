class SynergyCore < Formula
  desc "Core of Synergy, the keyboard and mouse sharing tool"
  homepage "https://symless.com/synergy"
  url "https://github.com/symless/synergy-core.git",
    :revision => "v2.0.0-stable"
  version "2.0.0"
  head "https://github.com/symless/synergy-core.git"

  bottle do
    sha256 "162a8d64cdcea7a71ec225ba5c9e6d6a677c2c16753750fc9759deab4d82c094" => :high_sierra
    sha256 "5e2a6518aaafcbfd4d29b66bac14db51fc5c4a70d662354fb4bd485b276f13ff" => :sierra
  end

  depends_on "cmake" => :build
  depends_on "qt"
  depends_on "openssl"

  def install
    mkdir "build" do
      system "cmake",
        "-DSYNERGY_CORE_INSTALL=1",
        "-DSYNERGY_BUNDLE_BINARY_DIR=#{prefix/bin}",
        "-DOSX_TARGET_MAJOR=10",
        "-DCMAKE_OSX_SYSROOT=#{MacOS.sdk_path}",
        "-DCMAKE_OSX_DEPLOYMENT_TARGET=10.9", # Target '10.9' works for MacOS 10.9 - 10.13
        "-DCMAKE_OSX_ARCHITECTURES=x86_64",
        *std_cmake_args,
        ".."

      system "make", "install"
    end
  end

  test do
    begin
      io = IO.popen("#{bin}/synergy-core --client --no-daemon 127.0.0.1")
      sleep 5
    ensure
      Process.kill("SIGINT", io.pid)
      Process.wait(io.pid)
    end

    io.read =~ /NOTE: connecting to '127.0.0.1': 127.0.0.1:24800/
  end
end
