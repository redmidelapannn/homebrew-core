class Tasksh < Formula
  desc "Shell wrapper for Taskwarrior commands"
  homepage "https://tasktools.org/projects/tasksh.html"
  url "https://taskwarrior.org/download/tasksh-1.2.0.tar.gz"
  sha256 "6e42f949bfd7fbdde4870af0e7b923114cc96c4344f82d9d924e984629e21ffd"
  head "https://github.com/GothenburgBitFactory/taskshell.git", :branch => "1.3.0"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "325bfab747a459f945a0eb8b5b9b478207b5242af5f1db1751d4383ff6ecd958" => :mojave
    sha256 "35990e4813065561f54a67925816bb41f326c3060793d4ffcce4982c54465678" => :high_sierra
    sha256 "574f6a6922d0af6ce5ea885a4e77a4904b5db60354d2f9a2af96651ab7f30fb3" => :sierra
    sha256 "83c0fa2256483ef1cf78816302f13d961bd8b8808ca0f3ca7b8b0512d47fb7ab" => :el_capitan
  end

  depends_on "cmake" => :build
  depends_on "task"

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    system "#{bin}/tasksh", "--version"
    (testpath/".taskrc").write "data.location=#{testpath}/.task\n"
    assert_match "Created task 1.", pipe_output("#{bin}/tasksh", "add Test Task", 0)
  end
end
