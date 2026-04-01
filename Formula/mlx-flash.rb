class MlxFlash < Formula
  desc "Run AI models too large for your Mac's memory — MoE expert caching for Apple Silicon"
  homepage "https://github.com/szibis/MLX-Flash"
  url "https://github.com/szibis/MLX-Flash/archive/refs/tags/v0.2.1.tar.gz"
  sha256 "6a24d5d6eeedef2f5ab9daf3f6faca8f538ae1c3e68462305c4a49480a39b4ae"
  license "MIT"

  depends_on :macos
  depends_on "python@3.12"
  depends_on "rust" => :build

  def install
    # Install Python package
    system "pip3", "install", "--prefix=#{prefix}", "."

    # Build Rust sidecar
    cd "mlx-flash-server" do
      system "cargo", "build", "--release"
      bin.install "target/release/mlx-flash-server"
    end
  end

  def caveats
    <<~EOS
      MLX-Flash requires Apple Silicon (M1/M2/M3/M4/M5).

      Quick start:
        mlx-flash --port 8080              # Start API server
        mlx-flash-chat                      # Interactive chat
        mlx-flash-browse                    # See what models fit

      For KV cache quantization (45% less memory):
        mlx-flash --port 8080 --kv-bits 8

      Documentation: https://github.com/szibis/MLX-Flash/tree/main/docs
    EOS
  end

  test do
    system "python3", "-c", "from mlx_flash_compress import __version__; print(__version__)"
  end
end
