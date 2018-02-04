class Tasksh < Formula
  desc "Shell wrapper for Taskwarrior commands"
  homepage "https://tasktools.org/projects/tasksh.html"
  url "https://taskwarrior.org/download/tasksh-1.2.0.tar.gz"
  sha256 "6e42f949bfd7fbdde4870af0e7b923114cc96c4344f82d9d924e984629e21ffd"
  head "https://github.com/GothenburgBitFactory/taskshell.git", :branch => "1.3.0"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "a101dbac172208468dc1e8ad9c75f10100b83c9e1b1b45993d2ac6f037f1ad5c" => :high_sierra
    sha256 "1a88f009b8e8452ec14fb4239c19317e012c09d6875e4efe438451e9d8d21016" => :sierra
    sha256 "8c91cf22f67b8fd63f72c97a21e1300ebd50ac395221dfce2942324b0e79ff71" => :el_capitan
  end

  depends_on "cmake" => :build
  depends_on "task" => :recommended

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
