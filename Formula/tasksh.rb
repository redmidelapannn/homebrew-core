class Tasksh < Formula
  desc "Shell wrapper for Taskwarrior commands"
  homepage "https://tasktools.org/projects/tasksh.html"
  url "https://taskwarrior.org/download/tasksh-1.1.0.tar.gz"
  sha256 "eef7c6677d6291b1c0e13595e8c9606d7f8dc1060d197a0d088cc1fddcb70024"
  head "https://git.tasktools.org/scm/ex/tasksh.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "a3432bdb927466c7bace4a0addc036487a17d6c61fc71cb329755a00eb625599" => :el_capitan
    sha256 "b883b5423acf239c933d94684432890cdc9be29cc2848352f00405974bbfe6e7" => :yosemite
    sha256 "db5d85e41c859639a2398e0403399d13da1f9823b681642dc75d1a171bc1ec89" => :mavericks
  end

  depends_on "cmake" => :build
  depends_on "task" => :recommended

  # Hangs trying to read task from stdin
  # Reported 6 Sep 2016 https://bug.tasktools.org/browse/TI-44?filter=-4
  # Also reported to support at taskwarrior.org
  patch do
    url "https://raw.githubusercontent.com/ilovezfs/formula-patches/de81b74/tasksh/tasksh-1.1.0-fix-hang.patch"
    sha256 "02011f7cf6d2e74ba716a8e87d53a5e26986d75f4a39c69eb406c3c85b551e8b"
  end

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    system "#{bin}/tasksh", "--version"
    (testpath/".taskrc").write "data.location=#{testpath}/.task\n"
    assert_match(/Created task 1./, pipe_output("#{bin}/tasksh", "add Test Task"))
  end
end
