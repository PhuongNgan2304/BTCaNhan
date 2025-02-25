require('dotenv').config();
//require('dotenv').config({ path: './src/.env' });
const express = require('express');
const cors = require('cors');
const connectDB = require('./src/config/database');
const authRoutes = require('./src/routes/authRoutes');
const userRoutes = require('./src/routes/userRoutes');
const homeRoutes = require('./src/routes/homeRoutes');
const productRoutes = require('./src/routes/productRoutes');


connectDB();
const app = express();
app.use(cors());
app.use(express.json());
app.use(express.urlencoded({ extended: true }));

app.use('/api/auth', authRoutes);
app.use('/api/user', userRoutes);
app.use('/api/home', homeRoutes);
app.use('/api/product', productRoutes);


const PORT = process.env.PORT || 5000;
app.listen(PORT, '0.0.0.0', () => console.log(`Server running on port ${PORT}`));
