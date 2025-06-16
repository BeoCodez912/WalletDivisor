const express = require("express");
const app = express();
const cors = require("cors");

app.use(cors());
app.use(express.json());

app.post("/apply-divisor", (req, res) => {
  const { amount } = req.body;
  const divisorAmount = parseFloat(amount) * 0.9;
  res.json({ divisorAmount: divisorAmount.toFixed(9) });
});

app.post("/divisor-deposit", (req, res) => {
  const { deposit } = req.body;
  const divisorDeposit = parseFloat(deposit) * 0.9;
  res.json({ divisorDeposit: divisorDeposit.toFixed(9) });
});

app.get("/", (req, res) => res.send("Divisor Wallet Backend Running"));

const PORT = process.env.PORT || 8080;
app.listen(PORT, () => console.log(`Server running on port ${PORT}`));
