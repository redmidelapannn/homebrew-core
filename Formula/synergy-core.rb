class SynergyCore < Formula
  desc "Open source core of Synergy, the keyboard and mouse sharing tool"
  homepage "https://symless.com/synergy"
  url "https://github.com/symless/synergy-core.git",
      :revision => "62ab8ffc4fdbc84b51552d600a8e11f7a7b78d84"
  version "1.9.0-rc4"
  head "https://github.com/symless/synergy-core.git"

  bottle do
    sha256 "d7955fd5708c72b8e3aaaadc090a8d2b0c0718a83db1de4e1708ff5ddf86543e" => :high_sierra
    sha256 "c45d16583a464a08755373995afba99d01b8554af86ca77532e5558c27c7667b" => :sierra
    sha256 "13a6e28ace0f8ddf111123795cdf8f63b26bb3031b411fdcbf6f5b53b21ac8a8" => :el_capitan
  end

  depends_on "cmake" => :build
  depends_on "qt"
  depends_on "openssh"

  def install
    mkdir "build" do
      system "cmake",
        "-DOSX_TARGET_MAJOR=10",
        "-DCMAKE_OSX_SYSROOT=#{MacOS.sdk_path}",
        "-DCMAKE_OSX_DEPLOYMENT_TARGET=10.9",
        "-DCMAKE_OSX_ARCHITECTURES=x86_64",
        ".."

      system "make"

      bin.install "bin/synergyc"
      bin.install "bin/synergys"
    end
  end

  test do
    assert_match version.to_s[0, 5], shell_output(bin/"synergys --version | head -1")
    assert_match version.to_s[0, 5], shell_output(bin/"synergyc --version | head -1")
  end
end
