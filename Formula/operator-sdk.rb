class OperatorSdk < Formula
  desc "SDK for building Kubernetes applications"
  homepage "https://coreos.com/operators/"
  url "https://github.com/operator-framework/operator-sdk/archive/v0.8.0.tar.gz"
  sha256 "03074ddfdcd23917978cc53c8f4f7d3093e083443fd4ec689a92edd50d568e2b"
  head "https://github.com/operator-framework/operator-sdk.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "00c9508980e19c233cd2c78829b8c92e96f449b5e464ccceacd8b6a9f4d5323d" => :mojave
    sha256 "c758e99be466d968d60620a4b9121b13375f9f07e77159fca22264e94193d9c9" => :high_sierra
    sha256 "95396c264eb257ce70db5d9f0b27f19721f68ad87d61f186295e8736c693c57b" => :sierra
  end

  depends_on "dep"
  depends_on "go"

  def install
    ENV["GOPATH"] = buildpath
    dir = buildpath/"src/github.com/operator-framework/operator-sdk"
    dir.install buildpath.children - [buildpath/".brew_home"]

    cd dir do
      # Make binary
      system "make", "install"
      bin.install buildpath/"bin/operator-sdk"

      # Install bash completion
      output = Utils.popen_read("#{bin}/operator-sdk completion bash")
      (bash_completion/"operator-sdk").write output

      # Install zsh completion
      output = Utils.popen_read("#{bin}/operator-sdk completion zsh")
      (zsh_completion/"_operator-sdk").write output

      prefix.install_metafiles
    end
  end

  test do
    ENV["GOPATH"] = testpath
    dir = testpath/"src/example.com/test-operator"
    dir.mkpath

    cd dir do
      # Create a new, blank operator framework
      system "#{bin}/operator-sdk", "new", "test"
    end
  end
end
