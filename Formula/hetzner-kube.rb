class HetznerKube < Formula
  desc "CLI tool for provisioning kubernetes clusters on Hetzner Cloud"
  homepage "https://github.com/xetys/hetzner-kube"
  url "https://github.com/xetys/hetzner-kube/archive/0.3.tar.gz"
  sha256 "300ad82fdeeb5f68d034571e1269025a2da73cd55be34a1cdb7f09257b1807af"

  bottle do
    cellar :any_skip_relocation
    sha256 "4343df9f30c2f0cad2665df48ffc424a80500fe0cfde0771566e9f4c68c943b3" => :high_sierra
    sha256 "310dd5539562f0ff7bef069816e300520717d2414616a0a8dcda5ff7cf7c3798" => :sierra
    sha256 "b14b9e4cbc0ba327607270639be04287d6f27cf4e3d5e1beb3cb2933848ec9d6" => :el_capitan
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath

    bin_path = buildpath/"src/github.com/xetys/hetzner-kube"
    bin_path.install Dir["*"]

    cd bin_path do
      system "go", "build", "-o", bin/"hetzner-kube", "."
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/hetzner-kube version")
  end
end
