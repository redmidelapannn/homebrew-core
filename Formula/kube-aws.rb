require "yaml"

class KubeAws < Formula
  desc "Kubernetes on AWS"
  homepage "https://github.com/coreos/coreos-kubernetes/tree/master/multi-node/aws"
  url "https://github.com/coreos/coreos-kubernetes/archive/v0.8.2.tar.gz"
  sha256 "85125641fca7431d8844192a22fb981dbd3de9c568aff2a7638812bf30f26d22"
  head "https://github.com/coreos/coreos-kubernetes.git"

  depends_on "go" => :build

  def install
    executable = "bin/kube-aws"
    ENV["GOPATH_VENDOR"] = "#{buildpath}/_gopath-vendor"
    ENV["GOPATH_KUBE_AWS"] = "#{buildpath}/_gopath-kube-aws"
    ENV["KUBE_AWS_DIR"] = "#{ENV["GOPATH_KUBE_AWS"]}/src/github.com/coreos/coreos-kubernetes/multi-node/aws"
    ENV["GOPATH"] = "#{ENV["GOPATH_VENDOR"]}:#{ENV["GOPATH_KUBE_AWS"]}"

    cd "#{buildpath}/multi-node/aws/" do
      mkdir_p ENV["GOPATH_VENDOR"]
      mkdir_p File.dirname(ENV["KUBE_AWS_DIR"])

      ln_s "#{Dir.pwd}/vendor", "#{ENV["GOPATH_VENDOR"]}/src"
      ln_s Dir.pwd.to_s, ENV["KUBE_AWS_DIR"]

      system "go", "generate", "./pkg/config"
      system "go", "build", "-ldflags", "-X github.com/coreos/coreos-kubernetes/multi-node/aws/pkg/cluster.VERSION=#{version}", "-a", "-tags", "netgo", "-installsuffix", "netgo", "-o", executable, "./cmd/kube-aws"

      bin.install executable => "kube-aws"
    end
  end

  test do
    cluster = { "clusterName" => "test-cluster", "externalDNSName" => "dns", "keyName" => "key", "region" => "west", "availabilityZone" => "zone", "kmsKeyArn" => "arn" }
    system "kube-aws", "init", "--cluster-name", "test-cluster", "--external-dns-name", "dns", "--region", "west", "--availability-zone", "zone", "--key-name", "key", "--kms-key-arn", "arn"
    installed_version = shell_output("#{bin}/kube-aws version 2>&1")
    cluster_info = YAML.load(File.read(File.join(Dir.pwd, "cluster.yaml")))

    assert_equal cluster, cluster_info
    assert_match "kube-aws version #{version}", installed_version
  end
end
