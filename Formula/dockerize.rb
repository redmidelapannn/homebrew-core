class Dockerize < Formula
  desc "Utility to simplify running applications in docker containers"
  homepage "https://github.com/jwilder/dockerize"
  url "https://github.com/jwilder/dockerize.git",
      :tag      => "v0.6.1",
      :revision => "7c5cd7c34dcf1c81f6b4db132ebceabdaae17153"

  bottle do
    cellar :any_skip_relocation
    sha256 "92b37585253c0f02eb97f32437d896948aba0f0ad1cc711338f807e384364df1" => :mojave
    sha256 "2953c3587fbf9b32de2a437e20e0884763f34611dde69486710acc410603d443" => :high_sierra
    sha256 "0f32fbe3524af07354d34f2af14df80b8310438a3ed2a7374a0043b4e7f047d3" => :sierra
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/jwilder/dockerize").install buildpath.children
    ENV.append_path "PATH", buildpath/"bin"
    cd "src/github.com/jwilder/dockerize" do
      system "make", "dist"
      bin.install "dist/darwin/amd64/dockerize"
    end
  end

  test do
    system "dist/darwin/amd64/dockerize", "--help"
  end
end
