class DockerCommander < Formula
  desc "Execute commands in docker containers"
  homepage "https://github.com/daylioti/docker-commander"
  url "https://github.com/daylioti/docker-commander.git",
   :tag      => "1.1.4"

  bottle do
    cellar :any_skip_relocation
    sha256 "7e31880aebe057c3ff40c0ba4f9b4b21183d6aae6466d16ba48756d9d3dfecd0" => :mojave
    sha256 "d5b9b31be2b232607514cb2ae3daf09c34440c692a855e9afa122e9cf289fdff" => :high_sierra
    sha256 "e8a7ea37ce9466278962e6119932d47db669af53c2d907bf994b617358d75fc1" => :sierra
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    ENV["GO111MODULE"] = "on"
    src = buildpath/"src/github.com/daylioti/docker-commander"
    src.install buildpath.children
    src.cd do
      system "go", "build", "-ldflags", "-X main.version=#{version}"
      bin.install "docker-commander"
      prefix.install_metafiles
    end
  end

  test do
    assert_equal version, shell_output("#{bin}/docker-commander -v")

    (testpath/"config.yml").write <<-EOS
      ubuntu: &ubuntu
        connect:
          from_image: ubuntu

      config:
        - name: group 1
          config:

            - name: command 1
              exec:
                <<: *ubuntu
                cmd: ls -lah

        - name: group 2
          config:
            - name: command 2
              exec:
                <<: *ubuntu
                cmd: ls -lah /var
    EOS

    # Test parsing configuration.
    # If configuration parsed - GUI will return error, since brew can't launch docker-commander GUI
    output = shell_output("#{bin}/docker-commander -c=#{testpath}/config.yml 2>&1", 2)
    assert_match "error while reading terminfo data", output
  end
end
