class Kcov < Formula
  desc "Code coverage tool for compiled programs, Python and Bash"
  homepage "https://simonkagstrom.github.com/kcov/index.html"
  url "https://github.com/SimonKagstrom/kcov/archive/v35.tar.gz"
  sha256 "74c172dae2ac2866e0adc91d3fd80276e5acb970d11ac71679a0f7336897a476"
  bottle do
    cellar :any_skip_relocation
    sha256 "5e7b405c26b6c1e25435beb56d739a9f32d5caf0cab19078c750665516cdbdc5" => :high_sierra
    sha256 "384a2e5dad9e7f79c7fdb67e7b726b5e3edb95966b24cb21401852dee49b3e41" => :sierra
    sha256 "8b375e52d9c4cd8a142273f168a1ba5305582d6dd232ff09c2b847e976ab8c9c" => :el_capitan
  end

  depends_on "bash" => :build
  depends_on "cmake" => :build
  depends_on "pkg-config" => :build

  def install
    system "cmake", "-G", "Unix Makefiles", "-DCMAKE_INSTALL_PREFIX=#{prefix}", "."
    system "make"

    # As per notes in https://github.com/SimonKagstrom/kcov/issues/166
    MachO::Tools.change_install_name("src/kcov",
      "@rpath/LLDB.framework/LLDB",
      "/Applications/Xcode.app/Contents/SharedFrameworks/LLDB.framework/LLDB")

    system "make", "install"
  end

  test do
   system "#{bin}/kcov", "--version"
  end
end
