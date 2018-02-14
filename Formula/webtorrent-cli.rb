require "language/node"

class WebtorrentCli < Formula
  desc "Command-line streaming torrent client"
  homepage "https://webtorrent.io/"
  url "https://registry.npmjs.org/webtorrent-cli/-/webtorrent-cli-1.11.0.tgz"
  sha256 "682f4c5f21aa40974fab3c2e2ea032f0e4af2c09472c9f934efa58e4514b8a03"

  bottle do
    rebuild 1
    sha256 "f2c523a1c2094234f7c175943749af161c52f893fb2d1ee45a74613de87deebc" => :high_sierra
    sha256 "ca4c32ade0f7eb4b2aa0b9941753643ad5e98c7a2c6f93277707912c9eac9913" => :sierra
    sha256 "78b383be32764d6630c525317a2aaf638c806b2d93de1363190dfc880c0da83e" => :el_capitan
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    magnet_uri = <<~EOS.gsub(/\s+/, "").strip
      magnet:?xt=urn:btih:9eae210fe47a073f991c83561e75d439887be3f3
      &dn=archlinux-2017.02.01-x86_64.iso
      &tr=udp://tracker.archlinux.org:6969
      &tr=http://tracker.archlinux.org:6969/announce
    EOS

    assert_equal <<~EOS.chomp, shell_output("#{bin}/webtorrent info '#{magnet_uri}'")
      {
        "xt": "urn:btih:9eae210fe47a073f991c83561e75d439887be3f3",
        "dn": "archlinux-2017.02.01-x86_64.iso",
        "tr": [
          "http://tracker.archlinux.org:6969/announce",
          "udp://tracker.archlinux.org:6969"
        ],
        "infoHash": "9eae210fe47a073f991c83561e75d439887be3f3",
        "name": "archlinux-2017.02.01-x86_64.iso",
        "announce": [
          "http://tracker.archlinux.org:6969/announce",
          "udp://tracker.archlinux.org:6969"
        ],
        "urlList": []
      }
    EOS
  end
end
