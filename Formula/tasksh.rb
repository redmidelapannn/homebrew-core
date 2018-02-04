class Tasksh < Formula
  desc "Shell wrapper for Taskwarrior commands"
  homepage "https://tasktools.org/projects/tasksh.html"
  url "https://taskwarrior.org/download/tasksh-1.2.0.tar.gz"
  sha256 "6e42f949bfd7fbdde4870af0e7b923114cc96c4344f82d9d924e984629e21ffd"
  head "https://github.com/GothenburgBitFactory/taskshell.git", :branch => "1.3.0"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "a712c0f28baa4911862fa0c282a3199e075ffb23ca4ed117fff3e76ec9ecf9c7" => :high_sierra
    sha256 "6e92d8e2cb05ff39921501af66b0ccddc3a19619b95f4babff48a781f4aa7d98" => :sierra
    sha256 "77fbeb2dd97e8286f3c4643c9e2c2a97459e45b03e4d7776229f81b3f8bd9c7a" => :el_capitan
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
