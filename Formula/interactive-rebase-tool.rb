class InteractiveRebaseTool < Formula
  desc "Ncurses sequence editor for git interactive rebase"
  homepage "https://gitrebasetool.mitmaro.ca/"
  url "https://github.com/MitMaro/git-interactive-rebase-tool/archive/1.0.0.tar.gz"
  sha256 "74dc96e59820bd3352984618d307d9b4de2e257aed65d0c8b3118580ffb6da56"

  bottle do
    cellar :any_skip_relocation
    sha256 "4ba9338ee4fdb8dd1eaed67b6a534bfbe0f4f7bc444f53f483cbb666e3a7aec8" => :mojave
    sha256 "f62d2d5988613ea5041288fe7788dd77ce9705e61dd581bf0b8d688eb92e9359" => :high_sierra
    sha256 "92f01fd39d2969c9fdcbb4149d3b76ba9cc62b7aec100497ac00fb1a6b90a71a" => :sierra
  end

  depends_on "rust" => :build
  depends_on "libgit2"
  depends_on "openssl"

  def install
    system "cargo", "install", "--root", prefix, "--path", "."
  end

  test do
    require "pty" # required for interactivity

    (testpath/"todo").write <<~EOS
      pick aaa Added tests
      fixup bbb Added tests
      pick ccc Added tests
    EOS

    correct = <<~EOS
      drop aaa Added tests
      fixup bbb Added tests
      pick ccc Added tests
    EOS

    PTY.spawn("interactive-rebase-tool", "todo") do |input, output, _pid|
      input.gets # get the input each time to simulate interactive tty
      sleep 0.1 # sleep to give the tool time to update state
      output.puts "d" # send lowercase d to interactive-rebase-tool to drop top commit
      sleep 0.1
      input.gets
      sleep 0.1
      output.puts "W" # send uppercase W to interactive-rebase-tool to write the file
      sleep 0.1
      input.gets
    end

    assert_equal (testpath/"todo").read, correct # assert the todo file is modified correctly
  end
end
