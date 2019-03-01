class Inlets < Formula
  desc "Expose your local endpoints to the Internet"
  homepage "https://github.com/alexellis/inlets"
  url "https://github.com/alexellis/inlets.git",
      :tag      => "0.5.7",
      :revision => "4c5a519b669cfb92d3ced715fc8e82489aded46a"

  bottle do
    cellar :any_skip_relocation
    sha256 "bcf670d0e059aa3598addbc4d43bfb3dca8063273c6f52d603923f062996297c" => :mojave
    sha256 "c694c4fc4bdbde3ff032d96d9cbd3569fae2b30dc9dd486a60c62840186fd4d7" => :high_sierra
    sha256 "57af7f645ce7b3039202187f22ede4d756fc533d13d7523109fdf4000f79bd4c" => :sierra
  end

  depends_on "go" => :build

  def install
    ENV["XC_ARCH"] = "amd64"
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/alexellis/inlets").install buildpath.children
    cd "src/github.com/alexellis/inlets" do
      commit = Utils.popen_read("git", "rev-parse", "HEAD").chomp
      system "go", "build", "-ldflags",
             "-s -w -X main.GitCommit=#{commit} -X main.Version=#{version}",
             "-a",
             "-installsuffix", "cgo", "-o", bin/"inlets"
      prefix.install_metafiles
    end
  end

  test do
    begin
      stable_resource = stable.instance_variable_get(:@resource)
      commit = stable_resource.instance_variable_get(:@specs)[:revision]
      inlets_version = shell_output("#{bin}/inlets -version")
      assert_match /\s#{commit}$/, inlets_version
      assert_match /\s#{version}$/, inlets_version
    end
  end
end

