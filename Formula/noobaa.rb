class Noobaa < Formula
  desc "CLI for managing NooBaa S3 service on Kubernetes/Openshift"
  homepage "https://github.com/noobaa/noobaa-operator"
  url "https://github.com/noobaa/noobaa-operator.git",
      :tag      => "v1.0.2",
      :revision => "e97aff3759afc0d08f20f42484ac475570e9cd4d"
  head "https://github.com/noobaa/noobaa-operator.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "5a9113bdf050e582e3df4ad60ae267c3c1a3854be99500e300ea932776e6a08c" => :mojave
    sha256 "b22f24679a7d11dc00cbbcce76eb47256dc9c0445a2a97dfdd47139fb5ceb2f6" => :high_sierra
    sha256 "94ec26be9e42c65aaba40231028c8491a85a638c3ea5de08870ae9dfab4e6d63" => :sierra
  end

  depends_on "go"

  def install
    ENV["GOPATH"] = buildpath
    ENV["GO111MODULE"] = "on"

    src = buildpath/"src/github.com/noobaa/noobaa-operator"
    src.install buildpath.children
    src.cd do
      system "go", "mod", "vendor"
      system "go", "generate"
      system "go", "build"
      bin.install "noobaa-operator" => "noobaa"
    end
  end

  test do
    output = `#{bin}/noobaa version 2>&1`
    pos = output.index "CLI version: 1.0.2"
    raise "Version check failed" if pos.nil?

    puts "Success"
  end
end
