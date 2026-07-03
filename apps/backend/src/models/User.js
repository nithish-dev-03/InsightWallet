import mongoose from 'mongoose';

const userSchema = new mongoose.Schema(
  {
    name: {
      type: String,
      required: [true, 'Name is required'],
      trim: true,
      minlength: 2,
      maxlength: 100,
    },
    email: {
      type: String,
      required: [true, 'Email is required'],
      unique: true,
      lowercase: true,
      trim: true,
      index: true,
    },
    title: {
      type: String,
      trim: true,
      default: '',
    },
    bio: {
      type: String,
      trim: true,
      default: '',
    },
    location: {
      type: String,
      trim: true,
      default: '',
    },
    avatar: {
      url: { type: String, default: '' },
      publicId: { type: String, default: '' },
    },
    currency: {
      type: String,
      default: 'USD',
      trim: true,
    },
    theme: {
      type: String,
      enum: ['light', 'dark', 'system'],
      default: 'system',
    },
    emailVerified: {
      type: Boolean,
      default: false,
    },
    biometricEnabled: {
      type: Boolean,
      default: false,
    },
  },
  {
    timestamps: true,
  }
);

userSchema.methods.toJSON = function () {
  const obj = this.toObject();
  obj.id = obj._id ? obj._id.toString() : '';
  if (obj.avatar && typeof obj.avatar === 'object') {
    obj.avatar = obj.avatar.url || '';
  }
  delete obj.__v;
  return obj;
};

// Map to "users" collection (default, but let's be explicit)
const User = mongoose.model('User', userSchema, 'users');
export default User;
