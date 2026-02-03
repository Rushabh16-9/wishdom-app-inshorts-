const mongoose = require('mongoose');

const storySchema = new mongoose.Schema({
    type: {
        type: String,
        enum: ['text', 'video'],
        required: true,
    },
    contentUrl: {
        type: String,
        // required if type is video
    },
    textContent: {
        type: String,
        // required if type is text
    },
    caption: {
        type: String,
    },
    author: {
        type: String,
        required: true,
        default: 'Anonymous',
    },
    hashtags: {
        type: [String],
        default: [],
    },
    likes: {
        type: Number,
        default: 0,
    },
    createdAt: {
        type: Date,
        default: Date.now,
    },
});

module.exports = mongoose.model('Story', storySchema);
