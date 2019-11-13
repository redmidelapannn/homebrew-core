class Lab < Formula
  desc "Lab wraps Git or Hub, making it simple to clone, fork, and interact with repositories on GitLab"
  homepage "https://github.com/zaquestion/lab"
  version "0.16.0"
  sha256 "bba7ca506343080de75c673aa8333cb97308a7b8e9e17547eb5325980c25c54a"
  url "https://github.com/zaquestion/lab/releases/download/v#{version}/lab_#{version}_darwin_amd64.tar.gz"

  def install
    bin.install "lab"
  end

  test do
    system "git", "init"
    %w[haunted house].each { |f| touch testpath/f }
    system "git", "add", "haunted", "house"
    system "git", "commit", "-a", "-m", "Initial Commit"
    lab_env_config = "LAB_CORE_HOST=foo LAB_CORE_USER=bar LAB_CORE_TOKEN=baz"
    assert_equal "haunted\nhouse", shell_output("#{lab_env_config} #{bin}/lab ls-files").strip
  end
end
