class LeelaZero < Formula
  desc "Neural Network Go engine with no human-provided knowledge"
  homepage "https://zero.sjeng.org/"
  # pull from git tag to get submodules
  url "https://github.com/leela-zero/leela-zero.git",
      :tag      => "v0.17",
      :revision => "3f297889563bcbec671982c655996ccff63fa253"

  bottle do
    cellar :any
    rebuild 1
    sha256 "0c3687187b9d8cecf1f6c4c6933422cc81c0fd99f5813b7455a187d0fd6d386a" => :catalina
    sha256 "562e2126788182f78b65d48a724cebf5837cb3494023c599413d2ed593e1abdd" => :mojave
    sha256 "8e69eb74cb4e7e6847751d190c9e31c14e3aac72fe22f649d0c6c68bf9871353" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "boost"

  resource "network" do
    url "https://zero.sjeng.org/networks/00ff08ebcdc92a2554aaae815fbf5d91e8d76b9edfe82c9999427806e30eae77.gz", :using => :nounzip
    sha256 "5302f23818c23e1961dff986ba00f5df5c58dc9c780ed74173402d58fdb6349c"
  end

  def install
    mkdir "build"
    cd "build" do
      system "cmake", "..", *std_cmake_args
      system "cmake", "--build", "."
      bin.install "leelaz"
    end
    pkgshare.install resource("network")
  end

  test do
    system "#{bin}/leelaz", "--help"
    assert_match /^= [A-T][0-9]+$/, pipe_output("#{bin}/leelaz --cpu-only --gtp -w #{pkgshare}/*.gz", "genmove b\n", 0)
  end
end
