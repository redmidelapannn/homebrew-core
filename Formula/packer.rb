class Packer < Formula
  desc "Tool for creating identical machine images for multiple platforms"
  homepage "https://packer.io"
  url "https://github.com/mitchellh/packer.git",
      :tag => "v0.12.3",
      :revision => "c0f2b4768d7f9265adb1aa3c91a0206ca707d91e"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "d5714c08943367b4ae2f223339c92e64e18dbb8fbba5b5c5cc9c4fc290570025" => :sierra
    sha256 "89ba711f59982626a38dd17c4f4a29670decb532f56320b3a4f33e6c14fa3f10" => :el_capitan
    sha256 "0496af64f2e33bc94739113f22a91d2abf7f78fa86176dd63869883c524298fe" => :yosemite
  end

  depends_on "go" => :build

  def install
    dir = buildpath/"src/github.com/mitchellh/packer"
    dir.install buildpath.children - [buildpath/".brew_home"]

    ENV["GOPATH"] = buildpath
    ENV.prepend_create_path "PATH", buildpath/"bin"

    cd dir do
      arch = MacOS.prefer_64_bit? ? "amd64" : "386"
      ENV["XC_OS"] = "darwin"
      ENV["XC_ARCH"] = arch
      system "make", "releasebin"

      bin.install buildpath/"bin/packer"
      zsh_completion.install "contrib/zsh-completion/_packer"
      prefix.install_metafiles
    end
  end

  test do
    minimal = testpath/"minimal.json"
    minimal.write <<-EOS.undent
      {
        "builders": [{
          "type": "amazon-ebs",
          "region": "us-east-1",
          "source_ami": "ami-59a4a230",
          "instance_type": "m3.medium",
          "ssh_username": "ubuntu",
          "ami_name": "homebrew packer test  {{timestamp}}"
        }],
        "provisioners": [{
          "type": "shell",
          "inline": [
            "sleep 30",
            "sudo apt-get update"
          ]
        }]
      }
    EOS
    system "#{bin}/packer", "validate", minimal
  end
end
