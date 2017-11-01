defmodule FractxEx do
  require ExPNG.Color, as: Color

  @maxi 200

  def mandelbrot(image, x0, x1, y0, y1) do
    # t1 = :os.system_time(:millisecond)

    pixels = for pixel_y <- 0..(image.height - 1), pixel_x <- 0..(image.width-  1), into: <<>> do
      dx = (x1 - x0) / image.width
      dy = (y1 - y0) / image.height
      x = x0 + pixel_x*dx
      y = y0 + pixel_y*dy

      iteration = iter(x, y)
      # iteration = :rand.uniform(254)

      round(iteration / @maxi * 255) |> Color.grayscale()
    end

    # IO.inspect :os.system_time(:millisecond) - t1

    %{image | pixels: pixels}
  end

  defp iter(x, y) do
    iter(x, y, 0, 0, 0)
  end

  defp iter(_, _, _, _, @maxi), do: @maxi
  # defp iter(_, _, x, y, i) when x*x + y*y >=4, do: i
  defp iter(x0, y0, x, y, i) do
    case {x*x, y*y} do
      {xx, yy} when xx + yy < 4 ->
        iter(x0, y0, xx - yy + x0, 2 * x*y + y0, i + 1)
      _ ->
        i
    end
  end

  def main(_) do
    width = 700
    height = 400
    x0 = -2.5
    x1 = 1.0
    y0 = -1.0
    y1 = 1.0

    path = Path.join([File.cwd!, "mandelbrot.png"])

    ExPNG.image(width, height)
    |> FractxEx.mandelbrot(x0, x1, y0, y1)
    |> ExPNG.write(path)
  end

end

