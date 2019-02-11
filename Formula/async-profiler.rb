class AsyncProfiler < Formula
  desc "Sampling CPU and HEAP profiler for Java"
  homepage "https://github.com/jvm-profiling-tools/async-profiler"
  url "https://github.com/jvm-profiling-tools/async-profiler/archive/v1.5.tar.gz"
  sha256 "ffe8281f745a8e55bf9485c9ed9d30e5c4934174275cdb73b32e47cde35fffdd"

  bottle do
    cellar :any
    sha256 "8550f7e0e4a0f0ec19e8c45d939f434bbfbed39d6d97da88f164927ef6461785" => :mojave
    sha256 "ae3c7124a4355cfc2efdeb1e97baee70cc4d453e76162c95bec72c6364746d12" => :high_sierra
    sha256 "2e7929e3d863bbf65566359b05bbd1dfa3a9b8fd1eadeee7529d38fab54e2530" => :sierra
  end

  depends_on :java

  def install
    system "make"

    libexec.install "build", "profiler.sh"
    bin.install_symlink libexec/"profiler.sh" => "async-profiler"
  end

  test do
    system bin/"async-profiler", "-v"
  end
end
