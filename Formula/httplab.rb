class Httplab < Formula
  desc "Interactive Web Server"
  homepage "https://github.com/gchaincl/httplab"
  url "https://github.com/gchaincl/httplab/archive/v0.2.1.tar.gz"
  sha256 "6a4a7b8fecd34cb95a8281d0f1f4fafdd78b23121e34ec64c7d294559e9ff207"

  bottle do
    cellar :any_skip_relocation
    sha256 "b5846b9545be9efbe601f7c98db350f00598a745ca735a4ee8ec4593e8b568f7" => :sierra
    sha256 "5cd123d4e5c636b005b659220e4a1065e9d5db6725af85b8631c5ca69a7d5579" => :el_capitan
    sha256 "4fa89d899874649e0277ee196f1f804152798509b0f144681699613062775e8d" => :yosemite
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/gchaincl/httplab").install buildpath.children
    cd "src/github.com/gchaincl/httplab" do
      system "go", "build", "-o", bin/"httplab"
      prefix.install_metafiles
    end
  end

  test do
    system "#{bin}/httplab", "-version"
  end
end
