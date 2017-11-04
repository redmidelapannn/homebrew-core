class Capture < Formula
  desc "Command-line utility for creating media files from video/audio hardware"
  homepage "https://github.com/krad/capture/"
  url "https://github.com/krad/capture/archive/0.0.1.tar.gz"
  sha256 "cdec379de2832b0a21ad5f3b973685f4684a0926166e70ba147003838fb1285d"

  bottle do
    cellar :any
    sha256 "0bdff8786972727a87be42923b3e3964781e7899fac60e0cdc7403fc57582a0b" => :high_sierra
    sha256 "63fcb358c651b6da69e331c4b747213d506f7e078a3e919e5e36ec070ab0fa7b" => :sierra
  end

  depends_on :xcode => ["9.0", :build]
  depends_on :macos => :sierra

  def install
    target_config = "release"
    system "swift", "build",
                    "--disable-sandbox",
                    "-c", target_config,
                    "-Xswiftc",
                    "-no-static-stdlib"

    get_build_path_cmd = ["swift",
                          "build",
                          "--show-bin-path",
                          "-c",
                          target_config].join(" ")

    build_dir   = `#{get_build_path_cmd}`.strip!
    path_to_lib = "#{build_dir}/libBuffie.dylib"
    path_to_bin = "#{build_dir}/capture"

    lib.install path_to_lib
    bin.install path_to_bin
  end

  test do
    assert_match "capture #{version}",
                 shell_output("#{bin}/capture").chomp
  end
end
