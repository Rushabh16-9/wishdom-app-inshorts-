const express = require('express');
const router = express.Router();
const Story = require('../models/Story');
// @desc    Get all stories (filter by search term: hashtags, caption, content, author)
// @access  Public
router.get('/', async (req, res) => {
    try {
        const { search } = req.query;
        let query = {};

        if (search) {
            const searchRegex = new RegExp(search, 'i');
            query = {
                $or: [
                    { hashtags: { $in: [searchRegex] } }, // Match regex in array
                    { caption: searchRegex },
                    { textContent: searchRegex },
                    { author: searchRegex }
                ]
            };
        }

        const stories = await Story.find(query).sort({ createdAt: -1 });
        res.json(stories);
        res.status(500).send('Server Error');
    } catch (err) {
        console.error(err.message);
        res.status(500).send('Server Error');
    }
});

// @route   POST /api/feed
// @desc    Create a new story (Simple version, just data)
// @access  Public
router.post('/', async (req, res) => {
    const { type, contentUrl, textContent, caption, author, hashtags } = req.body;

    try {
        const newStory = new Story({
            type,
            contentUrl,
            textContent,
            caption,
            author,
            hashtags: hashtags || [],
        });

        const story = await newStory.save();
        res.json(story);
    } catch (err) {
        console.error(err.message);
        res.status(500).send('Server Error');
    }
});

// @route   DELETE /api/feed/:id
// @desc    Delete a story
// @access  Public
router.delete('/:id', async (req, res) => {
    try {
        const story = await Story.findById(req.params.id);
        if (!story) {
            return res.status(404).json({ msg: 'Story not found' });
        }
        await story.deleteOne();
        res.json({ msg: 'Story removed' });
    } catch (err) {
        console.error(err.message);
        if (err.kind === 'ObjectId') {
            return res.status(404).json({ msg: 'Story not found' });
        }
        res.status(500).send('Server Error');
    }
});

module.exports = router;
