class Jiri < Formula
  desc "Tool to simplify multi-repo development"
  homepage "https://fuchsia.googlesource.com/jiri"
  url "https://fuchsia.googlesource.com/jiri.git",
      :revision => "c76f9edefeb0eac2cf89d9ff6f5bb6df44477922"
  version "c76f9edefeb0eac2cf89d9ff6f5bb6df44477922"

  head "https://fuchsia.googlesource.com/jiri.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "a3cbf6efd6e1bf250b02675796aa88ad22caadaeb648398daa2b7c6603ae3746" => :mojave
    sha256 "0bb8f36bb5d4ce4e9857f28bd9ffd3dc9ea116826692df8ca52446ddfeda139f" => :high_sierra
    sha256 "4e7976ed63b1b2bd8ef85a95ad39c896377a1beb00ce08e17c3139d68a9a41f6" => :sierra
  end

  depends_on "go" => :build

  resource "gonet" do
    url "https://github.com/golang/net.git",
        :branch => "release-branch.go1.12"
  end

  resource "gosync" do
    url "https://github.com/golang/sync.git",
        :commit => "112230192c580c3556b8cee6403af37a4fc5f28c"
  end

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/fuchsia.googlesource.com/jiri").install buildpath.children
    (buildpath/"src/golang.org/x/net").install resource("gonet")
    (buildpath/"src/golang.org/x/sync").install resource("gosync")

    system "go", "install", "fuchsia.googlesource.com/jiri/cmd/jiri"
    bin.install "bin/jiri"
  end

  test do
    system "#{bin}/jiri", "--help"
  end
end
